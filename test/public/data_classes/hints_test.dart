// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';

void main() {
  final allHintsMap = const Hints(
    cardNumber: 'Card',
    expiration: 'Exp',
    cvv: 'Sec Code',
    postalCode: 'Zip',
  ).toMap();

  final defaultHintsMap = const Hints.only().toMap();

  group('Hints:', () {
    group('toMap():', () {
      group('All Hints:', () {
        test('Has correct length', () {
          expect(allHintsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(allHintsMap.containsKey('CardNumber'), true);
          expect(allHintsMap.containsKey('Expiration'), true);
          expect(allHintsMap.containsKey('Cvv'), true);
          expect(allHintsMap.containsKey('PostalCode'), true);
        });

        test('Keys have correct values', () {
          expect(allHintsMap['CardNumber'], 'Card');
          expect(allHintsMap['Expiration'], 'Exp');
          expect(allHintsMap['Cvv'], 'Sec Code');
          expect(allHintsMap['PostalCode'], 'Zip');
        });
      });

      group('Default Hints:', () {
        test('Has correct length', () {
          expect(defaultHintsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(defaultHintsMap.containsKey('CardNumber'), true);
          expect(defaultHintsMap.containsKey('Expiration'), true);
          expect(defaultHintsMap.containsKey('Cvv'), true);
          expect(defaultHintsMap.containsKey('PostalCode'), true);
        });

        test('Keys have correct values', () {
          expect(defaultHintsMap['CardNumber'], '4242 4242 4242 4242');
          expect(defaultHintsMap['Expiration'], 'MM/YY');
          expect(defaultHintsMap['Cvv'], 'CVV');
          expect(defaultHintsMap['PostalCode'], 'Postal Code');
        });
      });
    });

    group('isEqualTo():', () {
      test('All values equal, equality passes', () {
        const hints1 = Hints.defaults;
        const hints2 = Hints.only();

        expect(hints1.isEqualTo(hints2), true);
        expect(hints2.isEqualTo(hints1), true);
      });

      test('cardNumber different, equality fails', () {
        const hints1 = Hints.only(cardNumber: "4242");
        const hints2 = Hints.only(cardNumber: 'Card');

        expect(hints1.isEqualTo(hints2), false);
        expect(hints2.isEqualTo(hints1), false);
      });

      test('expiration different, equality fails', () {
        const hints1 = Hints.only(expiration: "Exp");
        const hints2 = Hints.only(expiration: 'MM/YY');

        expect(hints1.isEqualTo(hints2), false);
        expect(hints2.isEqualTo(hints1), false);
      });

      test('cvv different, equality fails', () {
        const hints1 = Hints.only(cvv: "cvc");
        const hints2 = Hints.only(cvv: 'cvv2');

        expect(hints1.isEqualTo(hints2), false);
        expect(hints2.isEqualTo(hints1), false);
      });

      test('postalCode different, equality fails', () {
        const hints1 = Hints.only(postalCode: "Zip");
        const hints2 = Hints.only(postalCode: 'Zip+4');

        expect(hints1.isEqualTo(hints2), false);
        expect(hints2.isEqualTo(hints1), false);
      });
    });
  });
}
