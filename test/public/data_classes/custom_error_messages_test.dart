// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_error_messages.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_field_errors.dart';

void main() {
  final allCustomErrorMessages = const CustomErrorMessages(
    number: CustomFieldErrors(
      emptyError: "Custom empty number",
      invalidError: "Custom invalid number",
    ),
    expiration: CustomFieldErrors(
      emptyError: "Custom empty expiration",
      invalidError: "Custom invalid expiration",
    ),
    cvv: CustomFieldErrors(
      emptyError: "Custom empty cvv",
      invalidError: "Custom invalid cvv",
    ),
    postalCode: CustomFieldErrors(
      emptyError: "Custom empty postalCode",
      invalidError: "Custom invalid postalCode",
    ),
    unsupportedCardError: "Custom unsupported card",
  ).toMap();

  final noCustomErrorMessages = const CustomErrorMessages.only().toMap();

  group('CustomErrorMessages:', () {
    group('toMap():', () {
      group('All CustomErrorMessages:', () {
        test('Has correct length', () {
          expect(allCustomErrorMessages.length, 5);
        });
        test('Has correct keys', () {
          expect(allCustomErrorMessages.containsKey('CardNumber'), true);
          expect(allCustomErrorMessages.containsKey('Expiration'), true);
          expect(allCustomErrorMessages.containsKey('Cvv'), true);
          expect(allCustomErrorMessages.containsKey('PostalCode'), true);
          expect(
              allCustomErrorMessages.containsKey('unsupportedCardError'), true);
        });
        test('Has correct values', () {
          expect(
            allCustomErrorMessages['CardNumber'],
            {
              'emptyError': 'Custom empty number',
              'invalidError': 'Custom invalid number'
            },
          );
          expect(
            allCustomErrorMessages['Expiration'],
            {
              'emptyError': 'Custom empty expiration',
              'invalidError': 'Custom invalid expiration'
            },
          );
          expect(
            allCustomErrorMessages['Cvv'],
            {
              'emptyError': 'Custom empty cvv',
              'invalidError': 'Custom invalid cvv'
            },
          );
          expect(
            allCustomErrorMessages['PostalCode'],
            {
              'emptyError': 'Custom empty postalCode',
              'invalidError': 'Custom invalid postalCode'
            },
          );
          expect(allCustomErrorMessages['unsupportedCardError'],
              "Custom unsupported card");
        });
      });

      group('Default CustomErrorMessages:', () {
        test('Has correct length', () {
          expect(noCustomErrorMessages.length, 5);
        });
        test('Has correct keys', () {
          expect(noCustomErrorMessages.containsKey('CardNumber'), true);
          expect(noCustomErrorMessages.containsKey('Expiration'), true);
          expect(noCustomErrorMessages.containsKey('Cvv'), true);
          expect(noCustomErrorMessages.containsKey('PostalCode'), true);
          expect(
              noCustomErrorMessages.containsKey('unsupportedCardError'), true);
        });
        test('Has correct values', () {
          expect(noCustomErrorMessages['CardNumber'], null);
          expect(noCustomErrorMessages['Expiration'], null);
          expect(noCustomErrorMessages['Cvv'], null);
          expect(noCustomErrorMessages['PostalCode'], null);
          expect(noCustomErrorMessages['unsupportedCardError'], null);
        });
      });
    });
  });
}
