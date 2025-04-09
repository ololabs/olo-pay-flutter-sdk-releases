// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/field_divider_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/private/data/form_creation_params.dart';

void main() {
  group('FormCreationParams', () {
    const hints = Hints.formDefaults;
    const textStyles = TextStyles.lightFormDefaults;
    const backgroundStyles = BackgroundStyles.lightFormDefaults;
    const fieldDividerStyles = FieldDividerStyles.formDefaults;
    const paddingStyles = PaddingStyles.defaults;
    const errorTextAlignment = TextFieldAlignment.right;
    const fontAsset = 'fontAsset';
    const errorFontAsset = 'errorFontAsset';
    const verticalSpacing = 10.0;
    const errorBackgroundStyles = BackgroundStyles.only();
    const errorPaddingStyles = PaddingStyles.noPadding;
    const focusedHints = Hints.formFocusedDefaults;

    final allFieldsMap =
        const FormCreationParams(
          hints: hints,
          textStyles: textStyles,
          backgroundStyles: backgroundStyles,
          fieldDividerStyles: fieldDividerStyles,
          paddingStyles: paddingStyles,
          focusedHints: focusedHints,
          errorBackgroundStyles: errorBackgroundStyles,
          errorPaddingStyles: errorPaddingStyles,
          verticalSpacing: verticalSpacing,
          errorAlignment: errorTextAlignment,
          fontAsset: fontAsset,
          errorFontAsset: errorFontAsset,
          enabled: false,
          darkMode: true,
        ).toMap();

    final requiredFieldsMap =
        const FormCreationParams(
          hints: hints,
          textStyles: textStyles,
          backgroundStyles: backgroundStyles,
          fieldDividerStyles: fieldDividerStyles,
          paddingStyles: paddingStyles,
          focusedHints: focusedHints,
          errorBackgroundStyles: errorBackgroundStyles,
          errorPaddingStyles: errorPaddingStyles,
          verticalSpacing: verticalSpacing,
          errorAlignment: errorTextAlignment,
          enabled: true,
          darkMode: false,
        ).toMap();

    group('toMap():', () {
      group('All Fields', () {
        test('Has correct length', () {
          expect(allFieldsMap.length, 14);
        });

        test('Has correct keys', () {
          expect(allFieldsMap.containsKey('hints'), true);
          expect(allFieldsMap.containsKey('textStyles'), true);
          expect(allFieldsMap.containsKey('backgroundStyles'), true);
          expect(allFieldsMap.containsKey('fieldDividerStyles'), true);
          expect(allFieldsMap.containsKey('paddingStyles'), true);
          expect(allFieldsMap.containsKey('focusedFieldHints'), true);
          expect(allFieldsMap.containsKey('errorBackgroundStyles'), true);
          expect(allFieldsMap.containsKey('errorPaddingStyles'), true);
          expect(allFieldsMap.containsKey('verticalSpacing'), true);
          expect(allFieldsMap.containsKey('errorTextAlignment'), true);
          expect(allFieldsMap.containsKey('fontAsset'), true);
          expect(allFieldsMap.containsKey('errorFontAsset'), true);
          expect(allFieldsMap.containsKey('enabled'), true);
          expect(allFieldsMap.containsKey('darkMode'), true);
        });

        test('Keys have correct values', () {
          expect(allFieldsMap['hints'], hints.toMap());
          expect(allFieldsMap['textStyles'], textStyles.toMap());
          expect(allFieldsMap['backgroundStyles'], backgroundStyles.toMap());
          expect(
            allFieldsMap['fieldDividerStyles'],
            fieldDividerStyles.toMap(),
          );
          expect(allFieldsMap['paddingStyles'], paddingStyles.toMap());
          expect(allFieldsMap['focusedFieldHints'], focusedHints.toMap());
          expect(
            allFieldsMap['errorBackgroundStyles'],
            errorBackgroundStyles.toMap(),
          );
          expect(
            allFieldsMap['errorPaddingStyles'],
            errorPaddingStyles.toMap(),
          );
          expect(allFieldsMap['verticalSpacing'], verticalSpacing);
          expect(
            allFieldsMap['errorTextAlignment'],
            errorTextAlignment.toString(),
          );
          expect(allFieldsMap['fontAsset'], fontAsset);
          expect(allFieldsMap['errorFontAsset'], errorFontAsset);
          expect(allFieldsMap['enabled'], false);
          expect(allFieldsMap['darkMode'], true);
        });
      });

      group('Required Fields', () {
        test('Has correct length', () {
          expect(requiredFieldsMap.length, 14);
        });

        test('Has correct keys', () {
          expect(requiredFieldsMap.containsKey('hints'), true);
          expect(requiredFieldsMap.containsKey('textStyles'), true);
          expect(requiredFieldsMap.containsKey('backgroundStyles'), true);
          expect(requiredFieldsMap.containsKey('fieldDividerStyles'), true);
          expect(requiredFieldsMap.containsKey('paddingStyles'), true);
          expect(requiredFieldsMap.containsKey('focusedFieldHints'), true);
          expect(requiredFieldsMap.containsKey('errorBackgroundStyles'), true);
          expect(requiredFieldsMap.containsKey('errorPaddingStyles'), true);
          expect(requiredFieldsMap.containsKey('verticalSpacing'), true);
          expect(requiredFieldsMap.containsKey('errorTextAlignment'), true);
          expect(requiredFieldsMap.containsKey('fontAsset'), true);
          expect(requiredFieldsMap.containsKey('errorFontAsset'), true);
          expect(requiredFieldsMap.containsKey('enabled'), true);
          expect(requiredFieldsMap.containsKey('darkMode'), true);
        });
        test('Keys have correct values', () {
          expect(requiredFieldsMap['hints'], hints.toMap());
          expect(requiredFieldsMap['textStyles'], textStyles.toMap());
          expect(
            requiredFieldsMap['backgroundStyles'],
            backgroundStyles.toMap(),
          );
          expect(
            requiredFieldsMap['fieldDividerStyles'],
            fieldDividerStyles.toMap(),
          );
          expect(requiredFieldsMap['paddingStyles'], paddingStyles.toMap());
          expect(requiredFieldsMap['focusedFieldHints'], focusedHints.toMap());
          expect(
            requiredFieldsMap['errorBackgroundStyles'],
            errorBackgroundStyles.toMap(),
          );
          expect(
            requiredFieldsMap['errorPaddingStyles'],
            errorPaddingStyles.toMap(),
          );
          expect(requiredFieldsMap['verticalSpacing'], verticalSpacing);
          expect(
            requiredFieldsMap['errorTextAlignment'],
            errorTextAlignment.toString(),
          );
          expect(requiredFieldsMap['fontAsset'], null);
          expect(requiredFieldsMap['errorFontAsset'], null);
          expect(requiredFieldsMap['enabled'], true);
          expect(requiredFieldsMap['darkMode'], false);
        });
      });
    });
  });
}
