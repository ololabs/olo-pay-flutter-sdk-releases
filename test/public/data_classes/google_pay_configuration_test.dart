// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_configuration.dart';

void main() {
  final allParamsMap =
      const GooglePayConfiguration(
        productionEnvironment: false,
        currencyMultiplier: 123,
        existingPaymentMethodRequired: true,
      ).toMap();

  final defaultParamsMap = const GooglePayConfiguration().toMap();

  group('GooglePayConfiguration:', () {
    group('toMap():', () {
      group('All Params', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(
            allParamsMap.containsKey('googlePayProductionEnvironment'),
            true,
          );
          expect(allParamsMap.containsKey("currencyMultiplier"), true);
          expect(
            allParamsMap.containsKey('existingPaymentMethodRequired'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(allParamsMap['googlePayProductionEnvironment'], false);
          expect(allParamsMap['currencyMultiplier'], 123);
          expect(allParamsMap['existingPaymentMethodRequired'], true);
        });
      });

      group('Required Params Only', () {
        test('Has correct length', () {
          expect(defaultParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(
            defaultParamsMap.containsKey('googlePayProductionEnvironment'),
            true,
          );
          expect(defaultParamsMap.containsKey('currencyMultiplier'), true);
          expect(
            defaultParamsMap.containsKey('existingPaymentMethodRequired'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(defaultParamsMap['googlePayProductionEnvironment'], true);
          expect(defaultParamsMap['currencyMultiplier'], 100);
          expect(defaultParamsMap['existingPaymentMethodRequired'], false);
        });
      });
    });
  });
}
