// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/public/data_classes/field_divider_styles.dart';

void main() {
  final allParamsMap = const FieldDividerStyles(
    dividerColor: Colors.white,
    dividerWidth: 5.0,
  ).toMap();

  final emptyParamsMap = const FieldDividerStyles.only().toMap();

  const colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.blue,
    onPrimary: Colors.blueAccent,
    secondary: Colors.green,
    onSecondary: Colors.greenAccent,
    error: Colors.red,
    onError: Colors.redAccent,
    surface: Colors.purple,
    onSurface: Colors.purpleAccent,
  );

  const inputDecorationTheme = InputDecorationTheme(
    fillColor: Colors.orange,
    outlineBorder: BorderSide(color: Colors.orangeAccent, width: 2),
  );

  group('FieldDividerStyles:', () {
    group('merge():', () {
      group('dividerColor:', () {
        test('No theme, uses defaultBorderColor', () {
          var newStyles = FieldDividerStyles.merge(theme: null);
          expect(
            newStyles.dividerColor,
            const Color.fromRGBO(189, 188, 188, 1),
          );
        });

        test('With theme, uses colorScheme.onBackground', () {
          var themeData = ThemeData(
            brightness: Brightness.dark,
            colorScheme: colorScheme,
          );

          var newStyles = FieldDividerStyles.merge(theme: themeData);

          expect(newStyles.dividerColor, colorScheme.onSurface);
        });

        test('With theme, uses inputDecorationTheme.outlineBorder.color', () {
          var themeData = ThemeData(
            brightness: Brightness.light,
            inputDecorationTheme: inputDecorationTheme,
          );

          var newStyles = FieldDividerStyles.merge(theme: themeData);

          expect(
            newStyles.dividerColor,
            inputDecorationTheme.outlineBorder!.color,
          );
        });
      });

      group('dividerWidth:', () {
        test('No theme, uses defaultDividerWidth', () {
          var newStyles = FieldDividerStyles.merge(theme: null);
          expect(newStyles.dividerWidth, 1.0);
        });

        test('With theme, uses inputDecorationTheme.outlineBorder.width', () {
          var themeData = ThemeData(
            brightness: Brightness.light,
            inputDecorationTheme: inputDecorationTheme,
          );

          var newStyles = FieldDividerStyles.merge(theme: themeData);

          expect(
            newStyles.dividerWidth,
            inputDecorationTheme.outlineBorder!.width,
          );
        });
      });
    });

    group('toMap():', () {
      group('All params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 2);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey("dividerColor"), true);
          expect(allParamsMap.containsKey("dividerWidth"), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap["dividerColor"], "#ffffffff");
          expect(allParamsMap["dividerWidth"], 5.0);
        });
      });

      group('Empty params:', () {
        test('Has correct length', () {
          expect(emptyParamsMap.length, 2);
        });
        test('Has correct keys', () {
          expect(emptyParamsMap.containsKey("dividerColor"), true);
          expect(emptyParamsMap.containsKey("dividerWidth"), true);
        });
        test('Keys have correct values', () {
          expect(emptyParamsMap["dividerColor"], null);
          expect(emptyParamsMap["dividerWidth"], null);
        });
      });
    });
  });
}
