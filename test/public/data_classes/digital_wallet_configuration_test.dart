// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/currency_code.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_configuration.dart';

void main() {
  final allParamsMap = const DigitalWalletConfiguration(
    companyLabel: "Company 1",
    countryCode: "CA",
    currencyCode: CurrencyCode.cad,
    emailRequired: true,
    phoneNumberRequired: true,
    fullNameRequired: true,
    fullBillingAddressRequired: true,
    applePayConfig: ApplePayConfiguration(merchantId: "merchant.com.id"),
    googlePayConfig: GooglePayConfiguration(),
  ).toMap();

  final requiredParamsMap =
      const DigitalWalletConfiguration(companyLabel: "Company 2").toMap();

  group('DigitalWalletConfiguration:', () {
    group('toMap():', () {
      group('All Params', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 11);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey("companyLabel"), true);
          expect(allParamsMap.containsKey("countryCode"), true);
          expect(allParamsMap.containsKey('currencyCode'), true);
          expect(allParamsMap.containsKey('emailRequired'), true);
          expect(allParamsMap.containsKey('phoneNumberRequired'), true);
          expect(allParamsMap.containsKey('fullNameRequired'), true);
          expect(allParamsMap.containsKey('fullBillingAddressRequired'), true);
          expect(allParamsMap.containsKey("merchantId"), true);
          expect(
            allParamsMap.containsKey('googlePayProductionEnvironment'),
            true,
          );
          expect(allParamsMap.containsKey('currencyMultiplier'), true);
          expect(
            allParamsMap.containsKey('existingPaymentMethodRequired'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(allParamsMap["companyLabel"], "Company 1");
          expect(allParamsMap["countryCode"], "CA");
          expect(allParamsMap['currencyCode'], "CAD");
          expect(allParamsMap['emailRequired'], true);
          expect(allParamsMap['phoneNumberRequired'], true);
          expect(allParamsMap['fullNameRequired'], true);
          expect(allParamsMap['fullBillingAddressRequired'], true);
          expect(allParamsMap["merchantId"], "merchant.com.id");
          expect(allParamsMap['googlePayProductionEnvironment'], true);
          expect(allParamsMap['currencyMultiplier'], 100);
          expect(allParamsMap['existingPaymentMethodRequired'], false);
        });
      });
      group('Required Params Only', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 7);
        });

        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey("companyLabel"), true);
          expect(requiredParamsMap.containsKey("countryCode"), true);
          expect(requiredParamsMap.containsKey('currencyCode'), true);
          expect(requiredParamsMap.containsKey('emailRequired'), true);
          expect(requiredParamsMap.containsKey('phoneNumberRequired'), true);
          expect(requiredParamsMap.containsKey('fullNameRequired'), true);
          expect(
            requiredParamsMap.containsKey('fullBillingAddressRequired'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap["companyLabel"], "Company 2");
          expect(requiredParamsMap["countryCode"], "US");
          expect(requiredParamsMap['currencyCode'], "USD");
          expect(requiredParamsMap['emailRequired'], false);
          expect(requiredParamsMap['phoneNumberRequired'], false);
          expect(requiredParamsMap['fullNameRequired'], false);
          expect(requiredParamsMap['fullBillingAddressRequired'], false);
        });
      });
    });
  });
}
