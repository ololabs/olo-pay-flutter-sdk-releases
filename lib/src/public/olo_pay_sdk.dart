// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/olo_pay_sdk_platform_interface.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_configuration.dart';
import 'package:flutter/services.dart';

/// The main entry point into the Flutter Olo Pay SDK.
///
/// This class is responsible for initializing the SDK (see [initializeOloPay])
/// and creating [PaymentMethod] instances via digital wallets
/// (see [createDigitalWalletPaymentMethod]).
///
/// **Important:** Attempting to create a [PaymentMethod] prior to initializing
/// the SDK will result in errors.
class OloPaySdk {
  /// Sets a callback to know when the ready state of digital wallets changes.
  ///
  /// Attempting to create a [PaymentMethod] via [createDigitalWalletPaymentMethod]
  /// when digital wallets are not in a ready state will result in errors.
  ///
  /// Changes in app state (such as the app going in the background) and certain
  /// method calls (see [updateDigitalWalletConfiguration]) can cause the
  /// readiness of digital wallets to change.
  ///
  /// **Important:** This callback can, and likely will, be called multiple
  /// times. It is recommended to keep this callback active and update your UI
  /// accordingly whenever the app is displaying digital wallet UIs.
  set onDigitalWalletReady(DigitalWalletReadyChanged? onDigitalWalletReady) {
    OloPaySdkPlatform.instance.onDigitalWalletReady = onDigitalWalletReady;
  }

  /// Initializes the Olo Pay SDK.
  ///
  /// **Important:** The SDK only needs to be initialized once, even if multiple
  /// instances of [OloPaySdk] are created/used.
  ///
  /// [productionEnvironment] determines if the SDK will be initialized for
  /// production or test environment usage.
  ///
  /// In order to enable digital wallets, a non-`null` [digitalWalletConfig]
  /// must be provided. To enable Apple Pay, the config must contain a non-`null`
  /// [DigitalWalletConfiguration.applePayConfig]. Similarly a non-`null`
  /// [DigitalWalletConfiguration.googlePayConfig] is required to enable
  /// Google Pay.
  ///
  /// **_Important:_** The Olo Pay SDK will be fully initialized when this method
  /// completes. However, digital wallets have an asynchronous callback to
  /// indicate when they are ready to be used. See [onDigitalWalletReady] for more
  /// information
  ///
  /// If an error occurs while initializing the SDK a [PlatformException] will
  /// be thrown. The [PlatformException.code] property on the exception can be
  /// used to determine what went wrong and take appropriate action. The
  /// [PlatformException.message] property can be used to get more information
  /// about what went wrong.
  ///
  /// When a [PlatformException] is thrown, the [PlatformException.code]
  /// property will be one of the following:
  /// - [ErrorCodes.invalidGooglePaySetup] _(Android Only)_
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.unexpectedError]
  Future<void> initializeOloPay({
    bool productionEnvironment = true,
    DigitalWalletConfiguration? digitalWalletConfig,
  }) async {
    return await OloPaySdkPlatform.instance.initializeOloPay(
      productionEnvironment: productionEnvironment,
      digitalWalletConfig: digitalWalletConfig,
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

  /// Update the configuration settings for digital wallets.
  ///
  /// This can be used to change configuration parameters for digital wallets.
  /// Calling this method will immediately invalidate digital wallet readiness
  /// and will cause the [onDigitalWalletReady] event to be called with a value
  /// of `false`
  ///
  /// Once the new configuration is ready to be used, the [onDigitalWalletReady]
  /// event will be triggered again with a value of `true`.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The
  /// [PlatformException.code] property on the exception can be used to
  /// determine what went wrong and take appropriate action. The
  /// [PlatformException.message] property can be used to get more information
  /// about what went wrong
  ///
  /// When a [PlatformException] is thrown, the [PlatformException.code]
  /// property will be one of the following:
  /// - [ErrorCodes.uninitializedSdk]
  /// - [ErrorCodes.invalidGooglePaySetup] _(Android Only)_
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.unexpectedError]
  Future<void> updateDigitalWalletConfiguration(
    DigitalWalletConfiguration configuration,
  ) async {
    return await OloPaySdkPlatform.instance.updateDigitalWalletConfiguration(
      configuration,
    );
  }

  /// Create a payment method via Apple Pay or Google Pay
  ///
  /// If the digital wallet flow is successful, a [PaymentMethod] will be
  /// returned. If the return value is `null` the user canceled the operation.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The
  /// [PlatformException.code] property on the exception can be used to
  /// determine what went wrong and take appropriate action. The
  /// [PlatformException.message] property can be used to get more information
  /// about what went wrong
  ///
  /// When a [PlatformException] is thrown, the [PlatformException.code]
  /// property will be one of the following:
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.generalError]
  /// - [ErrorCodes.uninitializedSdk]
  /// - [ErrorCodes.uninitializedDigitalWallet]
  /// - [ErrorCodes.invalidParameter]
  /// - [ErrorCodes.digitalWalletNotReady]
  /// - [ErrorCodes.emptyCompanyName]
  /// - [ErrorCodes.emptyCountryCode]
  /// - [ErrorCodes.invalidCountryCode]
  /// - [ErrorCodes.lineItemTotalMismatch]
  /// - [ErrorCodes.applePayUnsupported] _(iOS Only)_
  /// - [ErrorCodes.emptyApplePayMerchantId] _(iOS Only)_
  /// - [ErrorCodes.googlePayInternalError] _(Android Only)_
  /// - [ErrorCodes.googlePayDeveloperError] _(Android Only)_
  /// - [ErrorCodes.googlePayNetworkError] _(Android Only)_
  Future<PaymentMethod?> createDigitalWalletPaymentMethod(
    DigitalWalletPaymentParameters paymentParams,
  ) async {
    return await OloPaySdkPlatform.instance.createDigitalWalletPaymentMethod(
      paymentParams,
    );
  }

  /// **_(iOS Only)_** Get a list of available font names
  ///
  /// This method is intended for debugging and troubleshooting font issues on
  /// iOS and should not be used in production.
  ///
  /// Registers all the fonts defined in [fontAssets] with iOS and returns a map
  /// of all font names installed on the iOS device. The map's key is the font
  /// family. The value for each key is a list of font names associated with the
  /// font family.
  ///
  /// The font names assocaited with custom font assets can be used with
  /// [TextStyles.iOSFontName] if they don't load properly or if the default
  /// font that loads is not the desired font name to be used.
  ///
  /// **_Important:_** For consistent behavior across devices, only use font
  /// names returned from this function that are associated with [fontAssets].
  ///
  /// If an error occurs a [PlatformException] will be thrown. The
  /// [PlatformException.code] property on the exception can be used to
  /// determine what went wrong and take appropriate action. The
  /// [PlatformException.message] property can be used to get more information
  /// about what went wrong
  ///
  /// When a [PlatformException] is thrown, the [PlatformException.code]
  /// property will be one of the following:
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.fontLoadError]
  /// - [ErrorCodes.assetNotFound]
  /// - [ErrorCodes.invalidParameter]
  Future<Map<String, List<String>>> getFontNames(
    List<String> fontAssets,
  ) async {
    return await OloPaySdkPlatform.instance.getFontNames(fontAssets);
  }
}
