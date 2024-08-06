// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_error_messages.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/private/data/creation_params.dart';

void main() {
  group('CreationParams:', () {
    const hints = Hints.defaults;
    const textStyles = TextStyles.only();
    const backgroundStyles = BackgroundStyles.only();
    const paddingStyles = PaddingStyles.defaults;
    const customErrorMessages = CustomErrorMessages.only();
    const textAlignment = TextFieldAlignment.left;

    final allParamsMap = const CreationParams(
            hints: hints,
            textStyles: textStyles,
            backgroundStyles: backgroundStyles,
            paddingStyles: paddingStyles,
            customErrorMessages: customErrorMessages,
            textAlignment: textAlignment)
        .toMap();

    final requiredParamsMap = const CreationParams(
      hints: hints,
      textStyles: textStyles,
      backgroundStyles: backgroundStyles,
      paddingStyles: paddingStyles,
    ).toMap();

    group('toMap():', () {
      group('All Params', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 6);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('hints'), true);
          expect(allParamsMap.containsKey('textStyles'), true);
          expect(allParamsMap.containsKey('backgroundStyles'), true);
          expect(allParamsMap.containsKey('paddingStyles'), true);
          expect(allParamsMap.containsKey('customErrorMessages'), true);
          expect(allParamsMap.containsKey('textAlignment'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['hints'], hints.toMap());
          expect(allParamsMap['textStyles'], textStyles.toMap());
          expect(allParamsMap['backgroundStyles'], backgroundStyles.toMap());
          expect(allParamsMap['paddingStyles'], paddingStyles.toMap());
          expect(
              allParamsMap['customErrorMessages'], customErrorMessages.toMap());
          expect(allParamsMap['textAlignment'], textAlignment.toString());
        });
      });

      group('Required Params Only', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 6);
        });

        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('hints'), true);
          expect(requiredParamsMap.containsKey('textStyles'), true);
          expect(requiredParamsMap.containsKey('backgroundStyles'), true);
          expect(requiredParamsMap.containsKey('paddingStyles'), true);
          expect(requiredParamsMap.containsKey('customErrorMessages'), true);
          expect(requiredParamsMap.containsKey('textAlignment'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['hints'], hints.toMap());
          expect(requiredParamsMap['textStyles'], textStyles.toMap());
          expect(
              requiredParamsMap['backgroundStyles'], backgroundStyles.toMap());
          expect(requiredParamsMap['paddingStyles'], paddingStyles.toMap());
          expect(requiredParamsMap['customErrorMessages'], null);
          expect(requiredParamsMap['textAlignment'], null);
        });
      });
    });
  });
}
