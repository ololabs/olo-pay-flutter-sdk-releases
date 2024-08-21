// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/olo_pay_sdk_platform_interface.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_vendor_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/olo_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:flutter/services.dart';

/// The main entry point into the Flutter Olo Pay SDK.
///
/// This class is responsible for initializing the SDK (see [initializeOloPay]) and creating [PaymentMethod] instances
/// via digital wallets (see [createDigitalWalletPaymentMethod]).
///
/// **Important:** Attempting to create a [PaymentMethod] prior to initializing the SDK will result in errors.
class OloPaySdk {
  /// Sets a callback to know when digital wallets are ready to process payments
  ///
  /// Attempting to create a [PaymentMethod] via [createDigitalWalletPaymentMethod] before digital wallets are ready will
  /// result in errors.
  ///
  /// #### **iOS Specific Behavior**
  ///
  /// If a device supports Apple Pay, it will be ready (and this callback will get called) as soon as the
  /// SDK is initialized. Once this callback indicates it's ready, it will always be ready.
  ///
  /// #### **Android Specific Behavior**
  ///
  /// It may take a noticeably longer time to initialize Google Pay than Apple Pay. Additionally, certain method calls
  /// (see [changeGooglePayVendor]) and other internal state changes can cause Google Pay to reinitialize, resulting in
  /// this callback getting called multiple times whenever the ready state changes.
  ///
  /// **Important:** It is recommended to keep this callback active and update your UI accordingly whenever the app
  /// is displaying digital wallet UIs.
  set onDigitalWalletReady(DigitalWalletReadyChanged? onDigitalWalletReady) {
    OloPaySdkPlatform.instance.onDigitalWalletReady = onDigitalWalletReady;
  }

  /// Initializes the Olo Pay SDK.
  ///
  /// **Important:** The SDK only needs to be initialized once, even if multiple instances of [OloPaySdk]
  /// are created/used.
  ///
  /// Use [oloPayParams] to specify how Olo Pay gets initialized.
  ///
  /// In order to enable Apple Pay, a non-`null` [applePayParams] must be supplied.
  ///
  /// Similarly, a non-`null` [googlePayParams] must be supplied to enable Google Pay. Additionally, the Android app's
  /// main activity must inherit from `FlutterFragmentActivity`. For details about this restriction, refer to the
  /// [Android-Specific Setup Steps](https://pub.dev/documentation/olo_pay_sdk/latest/index.html#android-specific-setup-steps)
  /// in the main ReadMe.
  ///
  /// **_Important:_** The Olo Pay SDK will be fully initialized when this method completes. However, digital wallets
  /// have an asynchronous callback to indicate when they are ready to be used. See [onDigitalWalletReady] for more
  /// information
  ///
  /// If an error occurs while initializing the SDK a [PlatformException] will be thrown. The `code` property on the
  /// exception can be used to determine what went wrong and take appropriate action. The `message` property can be used
  /// to get more information about what went wrong.
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// - [ErrorCodes.invalidGooglePaySetup]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.unexpectedError]
  Future<void> initializeOloPay({
    required OloPaySetupParameters oloPayParams,
    ApplePaySetupParameters? applePayParams,
    GooglePaySetupParameters? googlePayParams,
  }) async {
    return await OloPaySdkPlatform.instance.initializeOloPay(
      oloPayParams: oloPayParams,
      applePayParams: applePayParams,
      googlePayParams: googlePayParams,
    );
  }

  /// Returns `true` if Olo Pay has been initialized, otherwise `false`
  Future<bool> isOloPayInitialized() async {
    return await OloPaySdkPlatform.instance.isOloPayInitialized();
  }

  /// Returns `true` if digital wallets are ready to be used, otherwise `false`
  ///
  /// **Note:** In most cases it is preferable to use [onDigitalWalletReady]
  Future<bool> isDigitalWalletReady() async {
    return await OloPaySdkPlatform.instance.isDigitalWalletReady();
  }

  /// Create a payment method via Apple Pay or Google Pay
  ///
  /// If the digital wallet flow is successful, a [PaymentMethod] will be returned. If the return value is `null` the
  /// user canceled the operation.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The `code` property on the exception can be used to determine
  /// what went wrong and take appropriate action. The `message` property can be used to get more information about what
  /// went wrong
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// - [ErrorCodes.generalError]
  /// - [ErrorCodes.uninitializedSdk]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.applePayUnsupported]
  /// - [ErrorCodes.googlePayNotReady]
  /// - [ErrorCodes.googlePayUninitialized]
  /// - [ErrorCodes.googlePayInternalError]
  /// - [ErrorCodes.googlePayDeveloperError]
  /// - [ErrorCodes.googlePayNetworkError]
  /// - [ErrorCodes.unexpectedError]
  Future<PaymentMethod?> createDigitalWalletPaymentMethod(
      DigitalWalletPaymentParameters paymentParams) async {
    return await OloPaySdkPlatform.instance
        .createDigitalWalletPaymentMethod(paymentParams);
  }

  /// Change the vendor information to be used by Google Pay
  ///
  /// This can be used to change the country code and/or vendor name that will be used for Google Pay. Calling this
  /// method will immediately invalidate Google Pay's ready status and will call [onDigitalWalletReady] with a value of
  /// `false`
  ///
  /// Once the new vendor information is ready to be used with Google Pay, [onDigitalWalletReady] will be called again
  /// with a value of `true`.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The `code` property on the exception can be used to determine
  /// what went wrong and take appropriate action. The `message` property can be used to get more information about what
  /// went wrong
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// - [ErrorCodes.uninitializedSdk]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.googlePayUninitialized]
  /// - [ErrorCodes.unexpectedError]
  Future<void> changeGooglePayVendor(
      GooglePayVendorParameters vendorParams) async {
    return await OloPaySdkPlatform.instance.changeGooglePayVendor(vendorParams);
  }

  /// **_(iOS Only)_** Get a list of available font names
  ///
  /// This method is intended for debugging and troubleshooting font issues on iOS and should not be used in production.
  ///
  /// Registers all the fonts defined in [fontAssets] with iOS and returns a map of all font names installed on the iOS
  /// device. The map's key is the font family. The value for each key is a list of font names associated with the font
  /// family.
  ///
  /// The font names assocaited with custom font assets can be used with [TextStyles.iOSFontName] if they don't
  /// load properly or if the default font that loads is not the desired font name to be used.
  ///
  /// **_Important:_** For consistent behavior across devices, only use font names returned from this function that are
  /// associated with [fontAssets].
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.fontLoadError]
  /// - [ErrorCodes.assetNotFound]
  /// - [ErrorCodes.invalidParameter]
  Future<Map<String, List<String>>> getFontNames(
      List<String> fontAssets) async {
    return await OloPaySdkPlatform.instance.getFontNames(fontAssets);
  }
}
