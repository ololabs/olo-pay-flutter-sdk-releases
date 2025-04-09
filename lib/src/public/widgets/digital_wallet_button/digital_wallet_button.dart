// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/digital_wallet_creation_params.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

/// A button for initiating digital wallet payments.
///
/// On Android, it will display a native Google Pay button and on iOS it will
/// display a native Apple Pay button.
///
/// Use the [onClicked] event handler to call
/// [OloPaySdk.createDigitalWalletPaymentMethod] and launch the digital wallet
/// payment sheet flow.
///
/// ### Android-Specific Details:
///
/// To display this widget, the Android app's main activity must inherit from
/// `FlutterFragmentActivity`. For details about this restriction, refer to the
/// [Android-Specific Setup Steps](https://pub.dev/documentation/olo_pay_sdk/latest/index.html#android-specific-setup-steps)
/// in the main ReadMe.
///
/// ### Sizing Considerations:
///
/// This widget hosts native Android and iOS buttons. The native views are
/// wrapped by a [ConstrainedBox] with default `constraints` set to
///  `BoxConstraints(maxHeight: 45)`. This can be customized using the
/// `constraints` property.
///
/// If the height of the Flutter container exceeds the height of the native
/// button, the native button will be centered vertically in the Flutter
/// container.
///
/// ### Example Implementation
///
/// ```dart
/// Future<void> onDigitalWalletButtonClicked() async {
///   DigitalWalletPaymentParameters paymentParams = DigitalWalletPaymentParameters(
///     amount: 1.23,
///   );
///
///   try {
///     // Present the Apple Pay or Google Pay payment sheet and generate a
///     // payment method
///     PaymentMethod? paymentMethod =
///       await _oloPaySdkPlugin?.createDigitalWalletPaymentMethod(paymentParams);
///
///     if (paymentMethod == null) {
///       // Handle user canceled state
///     } else {
///       // Use paymentMethod to submit an order to Olo's Ordering API:
///       // https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API
///     }
///   } on PlatformException catch (e) {
///     // Handle errors
///   }
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   if (_digitalWalletsReady)
///     DigitalWalletButton(
///       onClicked: onDigitalWalletButtonClicked,
///     ),
/// }
/// ```
class DigitalWalletButton extends StatefulWidget {
  /// Creates a new instance of this widget
  ///
  /// Use [onClicked] to handle button clicks.
  ///
  /// Use [enabled] to control whether or not the button should respond to user
  /// clicks
  ///
  /// The [constraints] property can be used to set the height of this widget.
  /// Note that the native button will be centered vertically if the height of
  /// this widget exceeds the height of the native button.
  ///
  /// Use [applePay] to configure the look and feel of the Apple Pay button and
  /// [googlePay] to configure the look and feel of the Google Pay button.
  const DigitalWalletButton({
    super.key,
    this.onClicked,
    this.applePay = const ApplePayButtonConfiguration.only(),
    this.constraints = const BoxConstraints(maxHeight: 45),
    this.enabled = true,
    this.googlePay = const GooglePayButtonConfiguration.only(),
  });

  /// Property to set the native view's height and width. Default is `BoxConstraints(maxHeight: 45)`
  final BoxConstraints constraints;

  /// Whether or not the button should be enabled and allow click events
  final bool enabled;

  /// A callback function to be executed when the digital wallet button is
  /// clicked
  final OnDigitalWalletButtonClicked? onClicked;

  /// Configuration parameters for displaying an Apple Pay Button
  final ApplePayButtonConfiguration applePay;

  /// Configuration parameters for displaying a Google Pay button
  final GooglePayButtonConfiguration googlePay;

  @override
  State<StatefulWidget> createState() => _DigitalWalletButtonState();
}

class _DigitalWalletButtonState extends State<DigitalWalletButton> {
  MethodChannel? _channel;
  bool _prematureRefresh = false;

  void onButtonClickedHandler() {
    widget.onClicked?.call();
  }

  Future<void> platformViewCreatedCallback(id) async {
    _channel = MethodChannel(
      '${DataKeys.digitalWalletButtonBaseMethodChannelKey}$id',
    );
    _channel!.setMethodCallHandler(onMethodCall);

    if (_prematureRefresh) {
      _prematureRefresh = false;
      refreshUI(
        DigitalWalletCreationParams(
          applePayConfig: widget.applePay,
          googlePayConfig: widget.googlePay,
          enabled: widget.enabled,
        ),
      );
    }
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case DataKeys.digitalWalletButtonClickedEventHandlerKey:
        return onButtonClickedHandler();
      default:
        assert(false, "No method name keys matched, no event callbacks called");
        return;
    }
  }

  Future<void> refreshUI(DigitalWalletCreationParams params) async {
    try {
      if (_channel == null) {
        _prematureRefresh = true;
        return;
      }

      return await _channel!.invokeOloMethod(DataKeys.refreshUiMethod, {
        DataKeys.creationParameters: params.toMap(),
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  @override
  void didUpdateWidget(covariant DigitalWalletButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldParams = DigitalWalletCreationParams(
      applePayConfig: oldWidget.applePay,
      googlePayConfig: oldWidget.googlePay,
      enabled: oldWidget.enabled,
    );

    final newParams = DigitalWalletCreationParams(
      applePayConfig: widget.applePay,
      googlePayConfig: widget.googlePay,
      enabled: widget.enabled,
    );

    if (!newParams.isEqualTo(oldParams)) {
      refreshUI(newParams);
    }
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = DataKeys.digitalWalletButtonViewTypeKey;

    final params =
        DigitalWalletCreationParams(
          applePayConfig: widget.applePay,
          googlePayConfig: widget.googlePay,
          enabled: widget.enabled,
        ).toMap();

    return ConstrainedBox(
      constraints: widget.constraints,
      child: Builder(
        builder: (context) {
          if (Platform.isAndroid) {
            return AndroidView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          } else {
            return UiKitView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          }
        },
      ),
    );
  }
}
