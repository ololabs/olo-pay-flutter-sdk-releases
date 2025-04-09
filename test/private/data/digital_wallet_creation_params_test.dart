// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/private/data/digital_wallet_creation_params.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_configuration.dart';

void main() {
  final paramsMap =
      const DigitalWalletCreationParams(
        applePayConfig: ApplePayButtonConfiguration.only(),
        googlePayConfig: GooglePayButtonConfiguration.only(),
        enabled: false,
      ).toMap();

  group('DigitalWalletCreationParams:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(paramsMap.length, 7);
      });

      test('Has correct keys', () {
        expect(paramsMap.containsKey('GooglePayButtonTheme'), true);
        expect(paramsMap.containsKey('GooglePayButtonType'), true);
        expect(paramsMap.containsKey('GooglePayButtonCornerRadius'), true);
        expect(paramsMap.containsKey('ApplePayButtonStyle'), true);
        expect(paramsMap.containsKey('ApplePayButtonType'), true);
        expect(paramsMap.containsKey('ApplePayButtonCornerRadius'), true);
        expect(paramsMap.containsKey('enabled'), true);
      });

      test('Keys have correct values', () {
        expect(paramsMap['GooglePayButtonTheme'], 'dark');
        expect(paramsMap['GooglePayButtonType'], 'checkout');
        expect(paramsMap['GooglePayButtonCornerRadius'], 8.0);
        expect(paramsMap['ApplePayButtonStyle'], 'black');
        expect(paramsMap['ApplePayButtonType'], 'checkout');
        expect(paramsMap['ApplePayButtonCornerRadius'], 8.0);
        expect(paramsMap['enabled'], false);
      });
    });
  });
}
