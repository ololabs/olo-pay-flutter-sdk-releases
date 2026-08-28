// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';

void main() {
  group('CardType:', () {
    group('fromStringValue():', () {
      test('Converts to visa', () {
        expect(CardType.visa, CardType.fromStringValue('Visa'));
      });

      test('Converts to americanExpress', () {
        expect(CardType.americanExpress, CardType.fromStringValue('Amex'));
      });

      test('Converts to discover', () {
        expect(CardType.discover, CardType.fromStringValue('Discover'));
      });

      test('Converts to masterCard', () {
        expect(CardType.masterCard, CardType.fromStringValue('Mastercard'));
      });

      test('Converts to unsupported', () {
        expect(CardType.unsupported, CardType.fromStringValue('Unsupported'));
      });

      test('Converts to unknown', () {
        expect(CardType.unknown, CardType.fromStringValue('Unknown'));
        expect(CardType.unknown, CardType.fromStringValue('lkjsen'));
      });
    });
  });
}
