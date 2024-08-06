// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';

void main() {
  final allParamsMap = const TextStyles(
    textColor: Colors.black,
    errorTextColor: Colors.orange,
    cursorColor: Colors.orangeAccent,
    hintTextColor: Colors.indigo,
    textSize: 12,
    fontAsset: "font asset",
    iOSFontName: "font name",
  ).toMap();

  final emptyParamsMap = const TextStyles.only().toMap();

  const colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue,
    onPrimary: Colors.blueAccent,
    secondary: Colors.green,
    onSecondary: Colors.greenAccent,
    error: Colors.red,
    onError: Colors.redAccent,
    background: Colors.yellow,
    onBackground: Colors.yellowAccent,
    surface: Colors.purple,
    onSurface: Colors.purpleAccent,
  );

  const inputDecorationTheme = InputDecorationTheme(
    errorStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.cyan),
  );

  const textSelectionTheme =
      TextSelectionThemeData(cursorColor: Colors.blueGrey);

  group('TextStyles:', () {
    group('merge():', () {
      group('textColor:', () {
        test('No theme, uses defaultLightThemeTextColor', () {
          final newStyles = TextStyles.merge(theme: null);
          expect(newStyles.textColor, const Color.fromRGBO(20, 20, 20, 1));
        });

        // NOTE: We do not have a test for ensuring colorScheme.onBackground is used
        //       if textTheme.bodyMedium is null because, even though that property
        //       is nullable, I could not find a configuration that would make it null
        test('With theme, uses textTheme.bodyMedium.color', () {
          final themeData = ThemeData(
            textTheme:
                const TextTheme(bodyMedium: TextStyle(color: Colors.blue)),
          );

          final newStyles = TextStyles.merge(theme: themeData);

          expect(newStyles.textColor, Colors.blue);
        });

        test('With otherStyles, uses otherStyles.textColor', () {
          final themeData = ThemeData(colorScheme: colorScheme);

          const otherStyles = TextStyles.only(textColor: Colors.amber);
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: themeData);

          expect(newStyles.textColor, otherStyles.textColor);
        });
      });

      group('errorTextColor:', () {
        test('No theme, uses defaultLightThemeErrorTextColor', () {
          final newStyles = TextStyles.merge(theme: null);
          expect(
              newStyles.errorTextColor, const Color.fromRGBO(196, 45, 50, 1));
        });

        test('With theme, uses colorScheme.error', () {
          final themeData = ThemeData(colorScheme: colorScheme);
          final newStyles = TextStyles.merge(theme: themeData);
          expect(newStyles.errorTextColor, colorScheme.error);
        });

        test('With theme, uses inputDecorationTheme.errorStyle.color', () {
          final themeData =
              ThemeData(inputDecorationTheme: inputDecorationTheme);
          final newStyles = TextStyles.merge(theme: themeData);

          expect(
              newStyles.errorTextColor, inputDecorationTheme.errorStyle!.color);
        });

        test('With otherStyles, uses otherStyles.errorTextColor', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = TextStyles.only(errorTextColor: Colors.amber);
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: themeData);

          expect(newStyles.errorTextColor, otherStyles.errorTextColor);
        });
      });

      group('cursorColor:', () {
        test('No theme, uses defaultCursorColor', () {
          final newStyles = TextStyles.merge(theme: null);
          expect(newStyles.cursorColor, Colors.grey);
        });

        test('With theme, uses colorScheme.primary', () {
          final themeData = ThemeData(colorScheme: colorScheme);
          final newStyles = TextStyles.merge(theme: themeData);
          expect(newStyles.cursorColor, colorScheme.primary);
        });

        test('With theme, uses textSelectionTheme.cursorColor', () {
          final themeData = ThemeData(textSelectionTheme: textSelectionTheme);
          final newStyles = TextStyles.merge(theme: themeData);

          expect(newStyles.cursorColor, textSelectionTheme.cursorColor);
        });

        test('With otherStyles, uses otherStyles.cursorColor', () {
          final themeData = ThemeData(
            colorScheme: colorScheme,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = TextStyles.only(cursorColor: Colors.amber);
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: themeData);

          expect(newStyles.cursorColor, otherStyles.cursorColor);
        });
      });

      group('hintTextColor:', () {
        test('No theme, uses defaultHintTextColor', () {
          final newStyles = TextStyles.merge(theme: null);
          expect(newStyles.hintTextColor, const Color.fromRGBO(91, 89, 89, 1));
        });

        test('With theme, uses theme.hintColor', () {
          final themeData = ThemeData(hintColor: Colors.amber);
          final newStyles = TextStyles.merge(theme: themeData);
          expect(newStyles.hintTextColor, Colors.amber);
        });

        test('With theme, uses inputDecoration.hintStyle.color', () {
          final themeData =
              ThemeData(inputDecorationTheme: inputDecorationTheme);
          final newStyles = TextStyles.merge(theme: themeData);

          expect(
              newStyles.hintTextColor, inputDecorationTheme.hintStyle!.color);
        });

        test('With otherStyles, uses otherStyles.hintTextColor', () {
          final themeData = ThemeData(
            hintColor: Colors.cyanAccent,
            inputDecorationTheme: inputDecorationTheme,
          );

          const otherStyles = TextStyles.only(hintTextColor: Colors.amber);
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: themeData);

          expect(newStyles.hintTextColor, otherStyles.hintTextColor);
        });
      });

      group('textSize:', () {
        test('No theme, uses defaultFontSize', () {
          final newStyles = TextStyles.merge(theme: null);
          expect(newStyles.textSize, 14.0);
        });

        // NOTE: We do not have a test for ensuring colorScheme.onBackground is used
        //       if textTheme.bodyMedium is null because, even though that property
        //       is nullable, I could not find a configuration that would make it null
        test('With theme, uses textTheme.bodyMedium.fontSize', () {
          final themeData = ThemeData(
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 11.0)),
          );

          final newStyles = TextStyles.merge(theme: themeData);

          expect(newStyles.textSize, 11.0);
        });

        test('With otherStyles, uses otherStyles.textSize', () {
          final themeData = ThemeData(
            textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 11.0)),
          );

          const otherStyles = TextStyles.only(textSize: 18.0);
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: themeData);

          expect(newStyles.textSize, otherStyles.textSize);
        });
      });

      group('fontAsset: ', () {
        test('With otherStyles, uses otherStyles.fontAsset', () {
          const otherStyles = TextStyles.only(fontAsset: "font");
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: null);

          expect(newStyles.fontAsset, otherStyles.fontAsset);
        });
      });

      group('iOSFontName: ', () {
        test('With otherStyles, uses otherStyles.iOSFontName', () {
          const otherStyles = TextStyles.only(iOSFontName: "name");
          final newStyles =
              TextStyles.merge(otherStyles: otherStyles, theme: null);

          expect(newStyles.iOSFontName, otherStyles.iOSFontName);
        });
      });
    });

    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 7);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey("textColor"), true);
          expect(allParamsMap.containsKey("errorTextColor"), true);
          expect(allParamsMap.containsKey("cursorColor"), true);
          expect(allParamsMap.containsKey("hintTextColor"), true);
          expect(allParamsMap.containsKey("textSize"), true);
          expect(allParamsMap.containsKey("fontAsset"), true);
          expect(allParamsMap.containsKey("fontName"), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap["textColor"], "#ff000000");
          expect(allParamsMap["errorTextColor"], "#ffff9800");
          expect(allParamsMap["cursorColor"], '#ffffab40');
          expect(allParamsMap["hintTextColor"], '#ff3f51b5');
          expect(allParamsMap["textSize"], 12.0);
          expect(allParamsMap["fontAsset"], "font asset");
          expect(allParamsMap["fontName"], "font name");
        });
      });

      group('Empty Params:', () {
        test('Has correct length', () {
          expect(emptyParamsMap.length, 7);
        });

        test('Has correct keys', () {
          expect(emptyParamsMap.containsKey("textColor"), true);
          expect(emptyParamsMap.containsKey("errorTextColor"), true);
          expect(emptyParamsMap.containsKey("cursorColor"), true);
          expect(emptyParamsMap.containsKey("hintTextColor"), true);
          expect(emptyParamsMap.containsKey("textSize"), true);
          expect(allParamsMap.containsKey("fontAsset"), true);
          expect(allParamsMap.containsKey("fontName"), true);
        });

        test('Keys have correct values', () {
          expect(emptyParamsMap["textColor"], null);
          expect(emptyParamsMap["errorTextColor"], null);
          expect(emptyParamsMap["cursorColor"], null);
          expect(emptyParamsMap["hintTextColor"], null);
          expect(emptyParamsMap["textSize"], null);
          expect(emptyParamsMap["fontAsset"], null);
          expect(emptyParamsMap["fontName"], null);
        });
      });
    });
  });
}
