// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_setup_parameters.dart';

void main() {
  final applePayParamsMap = const ApplePaySetupParameters(
    merchantId: "com.merchant.test",
    companyLabel: "Test Company",
  ).toMap();

  group('ApplePaySetupParameters:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(applePayParamsMap.length, 2);
      });

      test('Has correct keys', () {
        expect(applePayParamsMap.containsKey("merchantId"), true);
        expect(applePayParamsMap.containsKey("companyLabel"), true);
      });

      test('Keys have correct values', () {
        expect(applePayParamsMap["merchantId"], "com.merchant.test");
        expect(applePayParamsMap["companyLabel"], "Test Company");
      });
    });
  });
}
