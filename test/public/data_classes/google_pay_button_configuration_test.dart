// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_configuration.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_theme.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_type.dart';

void main() {
  final allParamsMap =
      const GooglePayButtonConfiguration(
        theme: GooglePayButtonTheme.light,
        type: GooglePayButtonType.book,
        cornerRadius: 14.2,
      ).toMap();

  final defaultParamsMap = const GooglePayButtonConfiguration.only().toMap();

  group('GooglePayButtonConfiguration:', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('GooglePayButtonTheme'), true);
          expect(allParamsMap.containsKey('GooglePayButtonType'), true);
          expect(allParamsMap.containsKey('GooglePayButtonCornerRadius'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['GooglePayButtonTheme'], 'light');
          expect(allParamsMap['GooglePayButtonType'], 'book');
          expect(allParamsMap['GooglePayButtonCornerRadius'], 14.2);
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(defaultParamsMap.length, 3);
        });

        test('Has correct keys', () {
          expect(defaultParamsMap.containsKey('GooglePayButtonTheme'), true);
          expect(defaultParamsMap.containsKey('GooglePayButtonType'), true);
          expect(
            defaultParamsMap.containsKey('GooglePayButtonCornerRadius'),
            true,
          );
        });

        test('Keys have correct values', () {
          expect(defaultParamsMap['GooglePayButtonTheme'], 'dark');
          expect(defaultParamsMap['GooglePayButtonType'], 'checkout');
          expect(defaultParamsMap['GooglePayButtonCornerRadius'], 8.0);
        });
      });
    });
  });
}
