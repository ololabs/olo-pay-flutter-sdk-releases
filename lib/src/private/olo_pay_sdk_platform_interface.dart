// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_vendor_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/olo_pay_setup_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'olo_pay_sdk_method_channel.dart';

abstract class OloPaySdkPlatform extends PlatformInterface {
  OloPaySdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static OloPaySdkPlatform _instance = MethodChannelOloPaySdk();

  static OloPaySdkPlatform get instance => _instance;

  static set instance(OloPaySdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  DigitalWalletReadyChanged? onDigitalWalletReady;

  Future<void> initializeOloPay({
    required OloPaySetupParameters oloPayParams,
    ApplePaySetupParameters? applePayParams,
    GooglePaySetupParameters? googlePayParams,
  }) async {
    throw UnimplementedError('initializeOloPay() has not been implemented.');
  }

  Future<bool> isOloPayInitialized() async {
    throw UnimplementedError('isOloPayInitialized() has not been implemented.');
  }

  Future<bool> isDigitalWalletReady() async {
    throw UnimplementedError(
        'isDigitalWalletReady() has not been implemented.');
  }

  Future<PaymentMethod?> createDigitalWalletPaymentMethod(
      DigitalWalletPaymentParameters paymentParams) async {
    throw UnimplementedError(
        'createDigitalWalletPaymentMethod() has not been implemented');
  }

  Future<void> changeGooglePayVendor(
      GooglePayVendorParameters vendorParams) async {
    throw UnimplementedError(
        'changeGooglePayVendor() has not been implemented');
  }

  Future<Map<String, List<String>>> getFontNames(
      List<String> fontAssets) async {
    throw UnimplementedError('getFontNames() has not been implemented');
  }
}
