// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_style.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_type.dart';

void main() {
  final allParamsMap = const ApplePayButtonConfiguration(
    style: ApplePayButtonStyle.whiteOutline,
    type: ApplePayButtonType.book,
    cornerRadius: 14.2,
  ).toMap();

  final defaultParamsMap = const ApplePayButtonConfiguration.only().toMap();

  group('ApplePayButtonConfiguration:', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('ApplePayButtonStyle'), true);
          expect(allParamsMap.containsKey('ApplePayButtonType'), true);
          expect(allParamsMap.containsKey('ApplePayButtonCornerRadius'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['ApplePayButtonStyle'], 'whiteOutline');
          expect(allParamsMap['ApplePayButtonType'], 'book');
          expect(allParamsMap['ApplePayButtonCornerRadius'], 14.2);
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(defaultParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(defaultParamsMap.containsKey('ApplePayButtonStyle'), true);
          expect(defaultParamsMap.containsKey('ApplePayButtonType'), true);
          expect(
            defaultParamsMap.containsKey('ApplePayButtonCornerRadius'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(defaultParamsMap['ApplePayButtonStyle'], 'black');
          expect(defaultParamsMap['ApplePayButtonType'], 'checkout');
          expect(defaultParamsMap['ApplePayButtonCornerRadius'], 8.0);
        });
      });
    });
  });
}
