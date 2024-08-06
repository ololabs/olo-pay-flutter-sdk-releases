// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';

void main() {
  group('CardField:', () {
    group('fromStringValue():', () {
      test('Converts to card number field', () {
        expect(CardField.cardNumber, CardField.fromStringValue("CardNumber"));
      });

      test('Converts to expiration field', () {
        expect(CardField.fromStringValue("Expiration"), CardField.expiration);
      });

      test('Converts to cvv field', () {
        expect(CardField.fromStringValue("Cvv"), CardField.cvv);
      });

      test('Converts to postal code field', () {
        expect(CardField.fromStringValue("PostalCode"), CardField.postalCode);
      });

      test('Converts invalid string to null', () {
        expect(CardField.fromStringValue("ljsdfu"), null);
      });
    });
  });
}
