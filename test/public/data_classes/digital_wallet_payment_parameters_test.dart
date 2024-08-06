// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';

void main() {
  final allParamsMap = const DigitalWalletPaymentParameters(
    amount: 120,
    currencyCode: "CAD",
    currencyMultiplier: 120,
    countryCode: "CA",
  ).toMap();

  final requiredParamsMap =
      const DigitalWalletPaymentParameters(amount: 234).toMap();

  group('DigitalWalletPaymentParameters:', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('amount'), true);
          expect(allParamsMap.containsKey('countryCode'), true);
          expect(allParamsMap.containsKey('currencyCode'), true);
          expect(allParamsMap.containsKey('currencyMultiplier'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['amount'], 120);
          expect(allParamsMap['countryCode'], 'CA');
          expect(allParamsMap['currencyCode'], 'CAD');
          expect(allParamsMap['currencyMultiplier'], 120);
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('amount'), true);
          expect(requiredParamsMap.containsKey('countryCode'), true);
          expect(requiredParamsMap.containsKey('currencyCode'), true);
          expect(requiredParamsMap.containsKey('currencyMultiplier'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['amount'], 234);
          expect(requiredParamsMap['countryCode'], "US");
          expect(requiredParamsMap['currencyCode'], "USD");
          expect(requiredParamsMap['currencyMultiplier'], 100);
        });
      });
    });
  });
}
