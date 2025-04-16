// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_configuration.dart';

void main() {
  final applePayParamsMap =
      const ApplePayConfiguration(merchantId: "com.merchant.test").toMap();

  group('ApplePayConfiguration:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(applePayParamsMap.length, 1);
      });

      test('Has correct keys', () {
        expect(applePayParamsMap.containsKey("merchantId"), true);
      });

      test('Keys have correct values', () {
        expect(applePayParamsMap["merchantId"], "com.merchant.test");
      });
    });
  });
}
