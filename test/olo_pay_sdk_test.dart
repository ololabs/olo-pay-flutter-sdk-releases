// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/private/olo_pay_sdk_platform_interface.dart';
import 'package:olo_pay_sdk/src/private/olo_pay_sdk_method_channel.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOloPaySdkPlatform
    with MockPlatformInterfaceMixin
    implements OloPaySdkPlatform {
  @override
  Future<void> initializeOloPay({
    bool productionEnvironment = true,
    DigitalWalletConfiguration? digitalWalletConfig,
  }) {
    // TODO: implement initializeOloPay
    throw UnimplementedError();
  }

  @override
  Future<bool> isOloPayInitialized() {
    // TODO: implement isOloPayInitialized
    throw UnimplementedError();
  }

  @override
  DigitalWalletReadyChanged? onDigitalWalletReady;

  @override
  Future<void> updateDigitalWalletConfiguration(
    DigitalWalletConfiguration configuration,
  ) {
    // TODO: implement updateDigitalWalletConfiguration
    throw UnimplementedError();
  }

  @override
  Future<PaymentMethod?> createDigitalWalletPaymentMethod(
    DigitalWalletPaymentParameters paymentParams,
  ) {
    // TODO: implement createDigitalWalletPaymentMethod
    throw UnimplementedError();
  }

  @override
  Future<bool> isDigitalWalletReady() {
    // TODO: implement isDigitalWalletReady
    throw UnimplementedError();
  }

  @override
  Future<Map<String, List<String>>> getFontNames(List<String> fontAssets) {
    // TODO: implement getFontNames
    throw UnimplementedError();
  }
}

void main() {
  final OloPaySdkPlatform initialPlatform = OloPaySdkPlatform.instance;

  test('$MethodChannelOloPaySdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOloPaySdk>());
  });

  // test('getPlatformVersion', () async {
  //   OloPaySdk oloPaySdkPlugin = OloPaySdk();
  //   MockOloPaySdkPlatform fakePlatform = MockOloPaySdkPlatform();
  //   OloPaySdkPlatform.instance = fakePlatform;

  //   expect(await oloPaySdkPlugin.getPlatformVersion(), '42');
  // });
}
