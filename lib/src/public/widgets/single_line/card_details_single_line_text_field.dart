// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/creation_params.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_error_messages.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/public/widgets/single_line/card_details_single_line_text_field_controller.dart';

/// Widget responsible for displaying a credit card input field
///
/// This widget displays all credit card input details in a single input field
///
/// **_Important:_** Card details are intentionally restricted for PCI compliance
///
/// ### Android-Specific Details:
///
/// To display this widget, the Android app's main activity must inherit from `FlutterFragmentActivity`. For details
/// about this restriction, refer to the [Android-Specific Setup Steps](https://pub.dev/documentation/olo_pay_sdk/latest/index.html#android-specific-setup-steps)
/// in the main ReadMe.
///
/// ### Sizing Considerations:
///
/// This widget hosts native Android and iOS views and an error label contained within a [Column].
/// The native view is wrapped by a [ConstrainedBox] with default `constraints` set to `BoxConstraints(maxHeight: 45)`.
/// This can be customized using the [constraints] property.
///
/// ### Sizing Behavior Prior to v1.2.0
///
/// Prior to v1.2.0 Android and iOS had different widget sizing behavior. The iOS native view
/// would properly resize to fit the size specified by its Flutter container widget.
///
/// The Android native view, however, would only take up as much space as it needed, according to its intrinsic content size.
/// If the size specified for its Flutter container widget's height was larger than the space it required, this would
/// lead to extra empty space below the Android native view.
///
/// This has been fixed in v1.2.0, and the Android native view now properly resizes to fit the size
/// specified by its Flutter container widget.
///
/// ### Example Implementation
///
/// ```dart
/// CardDetailsSingleLineTextFieldController? _cardInputController;
///
/// void onSingleLineControllerCreated(CardDetailsSingleLineTextFieldController controller) {
///   _cardInputController = controller;
/// }
///
/// Future<void> createPaymentMethod() async {
///   try {
///     var paymentMethod = await _cardInputController?.createPaymentMethod();
///     if (paymentMethod != null) {
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
///   return Center(
///     child: Column(
///       children: <Widget>[
///         CardDetailsSingleLineTextField(
///           onControllerCreated: onSingleLineControllerCreated,
///         ),
///         ElevatedButton(
///           onPressed: createPaymentMethod,
///           child: const Text("Submit Card Details"),
///         ),
///       ],
///     ),
///   ),
/// }
/// ```
class CardDetailsSingleLineTextField extends StatefulWidget {
  /// Creates a new instance of this widget
  ///
  /// [onControllerCreated] can be used to get an instance of the controller associated with this widget.
  ///
  /// [onErrorMessageChanged] allows a way to get error messages to display to the user as they enter card details.
  ///
  /// [onInputChanged] provides the state of the widget any time the input values change.
  ///
  /// [onValidStateChanged] provides the state of the widget any time the state toggles between invalid and valid.
  ///
  /// [onFocusChanged] provides the state of the widget any time focus changes within the widget.
  ///
  /// The [constraints] property can be used to set the height of the native views.
  ///
  /// Set [customErrorMessages] to override error messages used by this widget. This can also be used to provide support for localization.
  ///
  /// Use [displayErrorMessages] to hide the built-in error label.
  ///
  /// Use the [errorAlignment] property to set the alignment of the built-in error message.
  ///
  /// The error message can be styled with the [errorStyles] property.
  ///
  /// The margin between the card input and the error message can be set with [errorMarginTop].
  ///
  /// Hint text can be changed with the [hints] property.
  ///
  /// To customize the text within the widget use [textStyles].
  ///
  /// Give the widget a custom background using [backgroundStyles].
  ///
  /// Use [paddingStyles] to customize the padding within the widget (this only affects Android).
  ///
  /// Use [enabled] to control whether the widget will respond to user interactions
  const CardDetailsSingleLineTextField({
    super.key,
    required this.onControllerCreated,
    this.backgroundStyles,
    this.customErrorMessages,
    this.errorStyles,
    this.onErrorMessageChanged,
    this.onFocusChanged,
    this.onInputChanged,
    this.onValidStateChanged,
    this.textStyles,
    this.constraints = const BoxConstraints(maxHeight: 45),
    this.displayErrorMessages = true,
    this.enabled = true,
    this.errorAlignment = Alignment.center,
    this.errorMarginTop = _defaultErrorMarginTop,
    this.hints = Hints.singleLineDefaults,
    this.paddingStyles = PaddingStyles.defaults,
  });

  /// @nodoc
  static const double _defaultErrorMarginTop = 8.0;

  /// A callback function to be notified when the controller associated with this widget is ready
  final CardDetailsSingleLineTextFieldControllerCreated onControllerCreated;

  /// A callback function to be notified when the error message associated with this widget changes
  final CardDetailsErrorMessageChanged? onErrorMessageChanged;

  /// A callback function to be notified when user-entered input changes
  final CardDetailsInputChanged? onInputChanged;

  /// A callback function to be notified when the valid state of this widget changes
  final CardDetailsValidStateChanged? onValidStateChanged;

  /// A callback function to be notified when the focused state of this widget changes
  final CardDetailsFocusChanged? onFocusChanged;

  /// Property to set the native view's height and width. Default is `BoxConstraints(maxHeight: 45)`
  final BoxConstraints constraints;

  /// Provide custom error messages
  final CustomErrorMessages? customErrorMessages;

  /// Determines if error messages are displayed. Default is `true`
  final bool displayErrorMessages;

  /// Alignment of the built-in error message. Default is `center`
  final Alignment errorAlignment;

  /// Customize the look and feel of the built-in error message
  final TextStyle? errorStyles;

  /// Set the margin between the input widget and the error message. Default is `8.0`
  final double errorMarginTop;

  /// Provide custom hint text for fields of this widget
  final Hints hints;

  /// Provide custom text styles for this widget
  ///
  /// Any properties that are `null` will be populated with values from the current theme,
  /// as defined by [TextStyles.merge]
  final TextStyles? textStyles;

  /// Provide custom background styles for this widget
  ///
  /// **Important:** On Android, this property will only have an effect on Android API 27 and newer
  final BackgroundStyles? backgroundStyles;

  /// Provide custom padding for this widget _**(Android Only)**_
  ///
  /// **Important:** When setting [PaddingStyles.topPadding] and [PaddingStyles.bottomPadding] it is important to note
  /// that a value of `0.0` may not necessarily mean the text touches the top and bottom border of the view. This is largely
  /// due to Flutter's requirements for providing a specific height for native views. See [CardDetailsSingleLineTextField]
  /// for more information on height/sizing guidelines.
  final PaddingStyles paddingStyles;

  /// Whether or not this widget will respond to user interactions
  final bool enabled;

  /// @nodoc
  @override
  State<CardDetailsSingleLineTextField> createState() =>
      _CardDetailsSingleLineTextFieldState();
}

class _CardDetailsSingleLineTextFieldState
    extends State<CardDetailsSingleLineTextField> {
  late CardDetailsSingleLineTextFieldController _controller;
  MethodChannel? _channel;
  bool prematureRefresh = false;
  String _editedFieldsErrorMessage = "";
  ThemeData? _themeData;

  Future<void> platformViewCreatedCallback(id) async {
    _channel = MethodChannel('${DataKeys.singleLineBaseMethodChannelKey}$id');
    _channel!.setMethodCallHandler(onMethodCall);

    _controller = CardDetailsSingleLineTextFieldController(
      _channel!,
      onControllerError,
    );
    widget.onControllerCreated.call(_controller);

    if (prematureRefresh) {
      prematureRefresh = false;
      refreshUI(
        CreationParams(
          hints: widget.hints,
          textStyles: TextStyles.merge(
            otherStyles: widget.textStyles,
            theme: _themeData,
          ),
          backgroundStyles: BackgroundStyles.merge(
            otherStyles: widget.backgroundStyles,
            theme: _themeData,
          ),
          paddingStyles: widget.paddingStyles,
          customErrorMessages: widget.customErrorMessages,
          enabled: widget.enabled,
        ),
      );
    }
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case DataKeys.onErrorMessageChangedEventHandlerKey:
        return errorMessageChangeHandler(call.arguments as String);
      case DataKeys.onInputChangedEventHandlerKey:
        return inputChangedHandler(call);
      case DataKeys.onValidStateChangedEventHandlerKey:
        return validStateChangedHandler(call);
      case DataKeys.onFocusChangedEventHandlerKey:
        return focusChangedHandler(call);
      default:
        return;
    }
  }

  void onControllerError(String errorMessage) {
    errorMessageChangeHandler(errorMessage);
  }

  void errorMessageChangeHandler(String errorMessage) {
    if (_editedFieldsErrorMessage != errorMessage) {
      setState(() {
        _editedFieldsErrorMessage = errorMessage;
      });
      widget.onErrorMessageChanged?.call(_editedFieldsErrorMessage);
    }
  }

  void inputChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final bool isValid = args[DataKeys.isValidKey];
    final Map<dynamic, dynamic> fieldStateArgs =
        args[DataKeys.fieldStatesParameterKey];

    widget.onInputChanged?.call(isValid, fieldStateArgs.toFieldStateMap());
  }

  void validStateChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final bool isValid = args[DataKeys.isValidKey];
    final Map<dynamic, dynamic> fieldStateArgs =
        args[DataKeys.fieldStatesParameterKey];

    widget.onValidStateChanged?.call(isValid, fieldStateArgs.toFieldStateMap());
  }

  void focusChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final bool isValid = args[DataKeys.isValidKey];
    final CardField? focusedField = CardField.fromStringValue(
      args[DataKeys.focusedFieldParameterKey],
    );
    final Map<dynamic, dynamic> fieldStateArgs =
        args[DataKeys.fieldStatesParameterKey];

    widget.onFocusChanged?.call(
      focusedField,
      isValid,
      fieldStateArgs.toFieldStateMap(),
    );
  }

  Future<void> refreshUI(CreationParams params) async {
    try {
      if (_channel == null) {
        prematureRefresh = true;
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
  void didUpdateWidget(covariant CardDetailsSingleLineTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    var newThemeData = Theme.of(context);

    final oldParams = CreationParams(
      textStyles: TextStyles.merge(
        otherStyles: oldWidget.textStyles,
        theme: _themeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: oldWidget.backgroundStyles,
        theme: _themeData,
      ),
      hints: oldWidget.hints,
      paddingStyles: oldWidget.paddingStyles,
      customErrorMessages: oldWidget.customErrorMessages,
      enabled: oldWidget.enabled,
    );

    final newParams = CreationParams(
      textStyles: TextStyles.merge(
        otherStyles: widget.textStyles,
        theme: newThemeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: widget.backgroundStyles,
        theme: newThemeData,
      ),
      hints: widget.hints,
      paddingStyles: widget.paddingStyles,
      customErrorMessages: widget.customErrorMessages,
      enabled: widget.enabled,
    );

    if (!newParams.isEqualTo(oldParams)) {
      _themeData = newThemeData;
      refreshUI(newParams);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    const String viewType = DataKeys.singleLineViewTypeKey;

    final params = CreationParams(
      hints: widget.hints,
      textStyles: TextStyles.merge(
        otherStyles: widget.textStyles,
        theme: _themeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: widget.backgroundStyles,
        theme: _themeData,
      ),
      paddingStyles: widget.paddingStyles,
      customErrorMessages: widget.customErrorMessages,
      enabled: widget.enabled,
    ).toMap();

    final defaultErrorStyles = TextStyle(
      color: TextStyles.getThemeAwareDefaultErrorTextColor(_themeData),
    );

    return Column(
      children: [
        ConstrainedBox(
          constraints: widget.constraints,
          child: Container(
            // Android has a thinner right border than left due to clipping for an unknown reason. Adding this margin
            // fixes the visual difference but also will cause misalignment by ~1px on the right side of this widget.
            // Example: sibling widgets wrapped in Padding
            margin: Platform.isAndroid ? const EdgeInsets.only(right: 1) : null,
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
          ),
        ),
        if (widget.displayErrorMessages)
          Column(
            children: [
              SizedBox(height: widget.errorMarginTop),
              Align(
                alignment: widget.errorAlignment,
                child: Text(
                  _editedFieldsErrorMessage,
                  style: widget.errorStyles ?? defaultErrorStyles,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
