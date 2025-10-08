// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_configuration.dart';

void main() {
  final applePayParamsMap = const ApplePayConfiguration(
          merchantId: "com.merchant.test", fullPhoneticNameRequired: true)
      .toMap();

  final emptyPhoneticNameParamsMap =
      const ApplePayConfiguration(merchantId: "com.merchant.test").toMap();

  group('ApplePayConfiguration:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(applePayParamsMap.length, 2);
      });

      test('Has correct keys', () {
        expect(applePayParamsMap.containsKey("merchantId"), true);
        expect(applePayParamsMap.containsKey('fullPhoneticNameRequired'), true);
      });

      test('Keys have correct values', () {
        expect(applePayParamsMap["merchantId"], "com.merchant.test");
        expect(applePayParamsMap["fullPhoneticNameRequired"], true);
      });
    });
  });

  group('Empty Phonetic Name Parameter:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(emptyPhoneticNameParamsMap.length, 2);
      });

      test('Has correct keys', () {
        expect(emptyPhoneticNameParamsMap.containsKey("merchantId"), true);
        expect(
            emptyPhoneticNameParamsMap.containsKey('fullPhoneticNameRequired'),
            true);
      });

      test('Keys have correct values', () {
        expect(emptyPhoneticNameParamsMap["merchantId"], "com.merchant.test");
        expect(emptyPhoneticNameParamsMap["fullPhoneticNameRequired"], false);
      });
    });
  });
}
