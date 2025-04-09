// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_field_errors.dart';

void main() {
  final allCustomFieldErrors =
      const CustomFieldErrors(
        emptyError: "Custom empty error",
        invalidError: "Custom invalid error",
      ).toMap();

  final noCustomFieldErrors = const CustomFieldErrors.only().toMap();

  group('CustomErrorMessages:', () {
    group('toMap():', () {
      group('All CustomErrorMessages:', () {
        test('Has correct length', () {
          expect(allCustomFieldErrors.length, 2);
        });
        test('Has correct keys', () {
          expect(allCustomFieldErrors.containsKey('emptyError'), true);
          expect(allCustomFieldErrors.containsKey('invalidError'), true);
        });
        test('Has correct values', () {
          expect(allCustomFieldErrors['emptyError'], 'Custom empty error');
          expect(allCustomFieldErrors['invalidError'], 'Custom invalid error');
        });
      });
      group('Default CustomErrorMessages:', () {
        test('Has correct length', () {
          expect(noCustomFieldErrors.length, 2);
        });
        test('Has correct keys', () {
          expect(noCustomFieldErrors.containsKey('emptyError'), true);
          expect(noCustomFieldErrors.containsKey('invalidError'), true);
        });
        test('Has correct values', () {
          expect(noCustomFieldErrors['emptyError'], null);
          expect(noCustomFieldErrors['invalidError'], null);
        });
      });
    });
  });
}
