// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_setup_parameters.dart';

void main() {
  final allParamsMap = const GooglePaySetupParameters(
    countryCode: "CA",
    merchantName: "Test Merchant 1",
    productionEnvironment: false,
    fullAddressFormat: true,
    existingPaymentMethodRequired: false,
    emailRequired: true,
    phoneNumberRequired: false,
  ).toMap();

  final requiredParamsMap = const GooglePaySetupParameters(
    countryCode: "US",
    merchantName: "Test Merchant 2",
  ).toMap();

  group('GooglePaySetupParameters:', () {
    group('toMap():', () {
      group('All Params', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 7);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('countryCode'), true);
          expect(allParamsMap.containsKey('merchantName'), true);
          expect(
              allParamsMap.containsKey('googlePayProductionEnvironment'), true);
          expect(allParamsMap.containsKey('fullAddressFormat'), true);
          expect(
              allParamsMap.containsKey('existingPaymentMethodRequired'), true);
          expect(allParamsMap.containsKey('emailRequired'), true);
          expect(allParamsMap.containsKey('phoneNumberRequired'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['countryCode'], 'CA');
          expect(allParamsMap['merchantName'], 'Test Merchant 1');
          expect(allParamsMap['googlePayProductionEnvironment'], false);
          expect(allParamsMap['fullAddressFormat'], true);
          expect(allParamsMap['existingPaymentMethodRequired'], false);
          expect(allParamsMap['emailRequired'], true);
          expect(allParamsMap['phoneNumberRequired'], false);
        });
      });

      group('Required Params Only', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 7);
        });

        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('countryCode'), true);
          expect(requiredParamsMap.containsKey('merchantName'), true);
          expect(
              requiredParamsMap.containsKey('googlePayProductionEnvironment'),
              true);
          expect(requiredParamsMap.containsKey('fullAddressFormat'), true);
          expect(requiredParamsMap.containsKey('existingPaymentMethodRequired'),
              true);
          expect(requiredParamsMap.containsKey('emailRequired'), true);
          expect(requiredParamsMap.containsKey('phoneNumberRequired'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['countryCode'], 'US');
          expect(requiredParamsMap['merchantName'], 'Test Merchant 2');
          expect(requiredParamsMap['googlePayProductionEnvironment'], true);
          expect(requiredParamsMap['fullAddressFormat'], false);
          expect(requiredParamsMap['existingPaymentMethodRequired'], true);
          expect(requiredParamsMap['emailRequired'], false);
          expect(requiredParamsMap['phoneNumberRequired'], false);
        });
      });
    });
  });
}
