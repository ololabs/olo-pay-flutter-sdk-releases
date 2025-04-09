// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_background_styles.dart';

void main() {
  final allParamsMap =
      const ErrorBackgroundStyles(
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 5.0,
        borderRadius: 1.0,
      ).toMap();

  final emptyParamsMap = const ErrorBackgroundStyles.only().toMap();

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

  group('ErrorBackgroundStyles:', () {
    group('merge():', () {
      group('backgroundColor:', () {
        test('No theme, uses defaultLightThemeBackgroundColor', () {
          var newStyles = ErrorBackgroundStyles.merge(theme: null);
          expect(newStyles.backgroundColor, Colors.white);
        });

        test('With theme, uses colorScheme.background', () {
          var themeData = ThemeData(
            brightness: Brightness.dark,
            colorScheme: colorScheme,
          );

          var newStyles = ErrorBackgroundStyles.merge(theme: themeData);

          expect(newStyles.backgroundColor, colorScheme.surface);
        });

        test('With theme, uses inputDecorationTheme.fillColor', () {
          var themeData = ThemeData(
            brightness: Brightness.light,
            inputDecorationTheme: inputDecorationTheme,
          );

          var newStyles = ErrorBackgroundStyles.merge(theme: themeData);

          expect(newStyles.backgroundColor, inputDecorationTheme.fillColor);
        });

        test('With otherStyles, uses otherStyles.backgroundColor', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = ErrorBackgroundStyles.only(
            backgroundColor: Colors.amber,
          );
          final newStyles = ErrorBackgroundStyles.merge(
            otherStyles: otherStyles,
            theme: themeData,
          );

          expect(newStyles.backgroundColor, otherStyles.backgroundColor);
        });
      });

      group('borderColor;', () {
        test('No theme, uses defaultBorderColor', () {
          var newStyles = ErrorBackgroundStyles.merge(theme: null);
          expect(newStyles.borderColor, const Color.fromRGBO(189, 188, 188, 1));
        });

        test('With theme, uses colorScheme.onBackground', () {
          var themeData = ThemeData(
            brightness: Brightness.dark,
            colorScheme: colorScheme,
          );

          var newStyles = ErrorBackgroundStyles.merge(theme: themeData);

          expect(newStyles.borderColor, colorScheme.onSurface);
        });

        test('With theme, uses inputDecorationTheme.outlineBorder.color', () {
          var themeData = ThemeData(
            brightness: Brightness.light,
            inputDecorationTheme: inputDecorationTheme,
          );

          var newStyles = ErrorBackgroundStyles.merge(theme: themeData);

          expect(
            newStyles.borderColor,
            inputDecorationTheme.outlineBorder!.color,
          );
        });

        test('With otherStyles, uses otherStyles.borderColor', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = ErrorBackgroundStyles.only(
            borderColor: Colors.amber,
          );
          final newStyles = ErrorBackgroundStyles.merge(
            otherStyles: otherStyles,
            theme: themeData,
          );

          expect(newStyles.borderColor, otherStyles.borderColor);
        });
      });

      group('borderWidth:', () {
        test('No theme, uses defaultBorderWidth', () {
          var newStyles = ErrorBackgroundStyles.merge(theme: null);
          expect(newStyles.borderWidth, 0.0);
        });

        test('With theme, uses inputDecorationTheme.outlineBorder.width', () {
          var themeData = ThemeData(
            brightness: Brightness.dark,
            inputDecorationTheme: inputDecorationTheme,
          );

          var newStyles = ErrorBackgroundStyles.merge(theme: themeData);

          expect(
            newStyles.borderWidth,
            inputDecorationTheme.outlineBorder!.width,
          );
        });

        test('With otherStyles, uses otherStyles.borderWidth', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = ErrorBackgroundStyles.only(borderWidth: 4.5);
          final newStyles = ErrorBackgroundStyles.merge(
            otherStyles: otherStyles,
            theme: themeData,
          );

          expect(newStyles.borderWidth, 4.5);
        });
      });

      group('borderRadius:', () {
        test('Without otherStyles, uses defaultBorderRadius', () {
          var newStyles = ErrorBackgroundStyles.merge(theme: null);
          expect(newStyles.borderRadius, 0.0);
        });

        test('With otherStyles, uses otherStyles.borderRadius', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = ErrorBackgroundStyles.only(borderRadius: 3.2);
          final newStyles = ErrorBackgroundStyles.merge(
            otherStyles: otherStyles,
            theme: themeData,
          );

          expect(newStyles.borderRadius, 3.2);
        });
      });

      group('toMap:', () {
        group('All Params:', () {
          test('Has correct length', () {
            expect(allParamsMap.length, 4);
          });

          test('Has correct keys', () {
            expect(allParamsMap.containsKey('backgroundColor'), true);
            expect(allParamsMap.containsKey('borderColor'), true);
            expect(allParamsMap.containsKey('borderWidth'), true);
            expect(allParamsMap.containsKey('borderRadius'), true);
          });

          test('Keys have correct values', () {
            expect(allParamsMap['backgroundColor'], "#ffffffff");
            expect(allParamsMap['borderColor'], "#ff000000");
            expect(allParamsMap['borderWidth'], 5.0);
            expect(allParamsMap['borderRadius'], 1.0);
          });
        });

        group('Empty Params:', () {
          test('Has correct length', () {
            expect(emptyParamsMap.length, 4);
          });

          test('Has correct keys', () {
            expect(emptyParamsMap.containsKey('backgroundColor'), true);
            expect(emptyParamsMap.containsKey('borderColor'), true);
            expect(emptyParamsMap.containsKey('borderWidth'), true);
            expect(emptyParamsMap.containsKey('borderRadius'), true);
          });

          test('Keys have correct values', () {
            expect(emptyParamsMap['backgroundColor'], null);
            expect(emptyParamsMap['borderColor'], null);
            expect(emptyParamsMap['borderWidth'], null);
            expect(emptyParamsMap['borderRadius'], null);
          });
        });
      });
    });
  });
}
