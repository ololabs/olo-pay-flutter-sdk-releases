// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/olo_pubspec.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_vendor_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/olo_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';

import 'olo_pay_sdk_platform_interface.dart';

class MethodChannelOloPaySdk extends OloPaySdkPlatform {
  final _methodChannel =
      const MethodChannel(DataKeys.oloPaySdkMethodChannelKey);

  @override
  Future<void> initializeOloPay({
    required OloPaySetupParameters oloPayParams,
    ApplePaySetupParameters? applePayParams,
    GooglePaySetupParameters? googlePayParams,
  }) async {
    _methodChannel.setMethodCallHandler(methodChannelHandler);

    final fileContent = await rootBundle.loadString(
      "packages/olo_pay_sdk/pubspec.yaml",
    );

    final oloPubspec = OloPubspec.parse(fileContent);
    String version = oloPubspec.version;
    String buildType = oloPubspec.buildType;

    try {
      await _methodChannel.invokeOloMethod(DataKeys.initializeMetadataKey, {
        DataKeys.version: version,
        DataKeys.buildType: buildType,
      });
    } catch (e) {
      // Intentional silent failure in production
      // Metadata failure should not impact functionality of SDK
      PlatformExceptionFactory.assertError(e);
    }

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return await initializeOloPayAndroid(
          oloPayParams: oloPayParams,
          googlePayParams: googlePayParams,
        );
      }

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await initializeOloPayIos(
          oloPayParams: oloPayParams,
          applePayParams: applePayParams,
        );
      }
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }

    throw UnimplementedError(
        'initializeOloPay() has not been implemented for platform: $defaultTargetPlatform');
  }

  @override
  Future<bool> isOloPayInitialized() async {
    try {
      return await _methodChannel
              .invokeOloMethod<bool>(DataKeys.isInitializedMethodKey) ??
          false;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  @override
  Future<bool> isDigitalWalletReady() async {
    try {
      return await _methodChannel
              .invokeOloMethod<bool>(DataKeys.isDigitalWalletReadyMethodKey) ??
          false;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  @override
  Future<PaymentMethod?> createDigitalWalletPaymentMethod(
      DigitalWalletPaymentParameters paymentParams) async {
    Map<dynamic, dynamic>? result;

    try {
      result = await _methodChannel.invokeOloMapMethod(
        DataKeys.createDigitalWalletPaymentMethodKey,
        paymentParams.toMap(),
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }

    if (result == null) {
      return null; // User cancelled digital wallet operation
    }

    if (result.containsKey(DataKeys.pmIdKey)) {
      return PaymentMethod(
        id: result[DataKeys.pmIdKey],
        last4: result[DataKeys.pmLast4Key],
        cardType: CardType.fromStringValue(result[DataKeys.pmCardTypeKey]),
        expirationMonth: result[DataKeys.pmExpirationMonthKey],
        expirationYear: result[DataKeys.pmExpirationYearKey],
        postalCode: result[DataKeys.pmPostalCodeKey],
        country: result[DataKeys.pmCountryCodeKey],
        isDigitalWallet: result[DataKeys.pmIsDigitalWalletKey],
        productionEnvironment: result[DataKeys.productionEnvironmentKey],
      );
    }

    //An error occurred
    String digitalWalletType = result[DataKeys.digitalWalletTypeParameterKey];
    String errorMessage = "$digitalWalletType: ${[
      DataKeys.digitalWalletErrorMessageParameterKey
    ]}";
    String? errorCode = result[DataKeys.googlePayErrorTypeParameterKey];

    throw PlatformExceptionFactory.create(
      errorDetails: errorMessage,
      errorCode: errorCode ?? ErrorCodes.generalError,
      userMessage: errorMessage,
      shouldAssert: false,
    );
  }

  @override
  Future<void> changeGooglePayVendor(
      GooglePayVendorParameters vendorParams) async {
    try {
      await _methodChannel.invokeOloMethod(
        DataKeys.changeGooglePayVendorMethodKey,
        vendorParams.toMap(),
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  @override
  Future<Map<String, List<String>>> getFontNames(
      List<String> fontAssets) async {
    Map<dynamic, List<dynamic>>? result;

    try {
      result = await _methodChannel.invokeOloMapMethod(
        DataKeys.getFontNamesMethodKey,
        {
          DataKeys.fontAssetListKey: fontAssets,
        },
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }

    if (result == null) {
      return {};
    }

    final resultMap = <String, List<String>>{};
    result.forEach((key, value) {
      resultMap[key] = value.map((name) => name.toString()).toList();
    });

    return resultMap;
  }

  Future<void> initializeOloPayAndroid({
    required OloPaySetupParameters oloPayParams,
    GooglePaySetupParameters? googlePayParams,
  }) async {
    await _methodChannel.invokeOloMethod(
      DataKeys.initializeMethodKey,
      {
        DataKeys.productionEnvironmentKey: oloPayParams.productionEnvironment,
      },
    );

    if (googlePayParams == null) {
      return;
    }

    await _methodChannel.invokeOloMethod(
      DataKeys.initializeGooglePayMethodKey,
      googlePayParams.toMap(),
    );
  }

  Future<void> initializeOloPayIos({
    required OloPaySetupParameters oloPayParams,
    ApplePaySetupParameters? applePayParams,
  }) async {
    var applePayArgs = applePayParams?.toMap();

    await _methodChannel.invokeOloMethod(
      DataKeys.initializeMethodKey,
      {
        DataKeys.productionEnvironmentKey: oloPayParams.productionEnvironment,
        DataKeys.applePaySetupArgsKey: applePayArgs,
      },
    );
  }

  Future<dynamic> methodChannelHandler(MethodCall call) async {
    if (call.method == DataKeys.digitalWalletReadyEventHandlerKey) {
      onDigitalWalletReady
          ?.call(call.arguments[DataKeys.digitalWalletReadyParameterKey]);
    }
  }
}
