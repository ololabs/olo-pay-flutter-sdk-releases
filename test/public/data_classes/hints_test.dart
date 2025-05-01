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

  final singleLineDefaultHintsMap = const Hints.singleLineOnly().toMap();

  final formDefaultHintsMap = const Hints.formOnly().toMap();

  final formFocusedDefaultHintsMap = const Hints.formFocusedOnly().toMap();

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

      group('Single Line Default Hints:', () {
        test('Has correct length', () {
          expect(singleLineDefaultHintsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(singleLineDefaultHintsMap.containsKey('CardNumber'), true);
          expect(singleLineDefaultHintsMap.containsKey('Expiration'), true);
          expect(singleLineDefaultHintsMap.containsKey('Cvv'), true);
          expect(singleLineDefaultHintsMap.containsKey('PostalCode'), true);
        });

        test('Keys have correct values', () {
          expect(
            singleLineDefaultHintsMap['CardNumber'],
            '4242 4242 4242 4242',
          );
          expect(singleLineDefaultHintsMap['Expiration'], 'MM/YY');
          expect(singleLineDefaultHintsMap['Cvv'], 'CVV');
          expect(singleLineDefaultHintsMap['PostalCode'], 'Postal Code');
        });
      });
    });

    group('Form Default Hints:', () {
      test('Has correct length', () {
        expect(formDefaultHintsMap.length, 4);
      });

      test('Has correct keys', () {
        expect(formDefaultHintsMap.containsKey('CardNumber'), true);
        expect(formDefaultHintsMap.containsKey('Expiration'), true);
        expect(formDefaultHintsMap.containsKey('Cvv'), true);
        expect(formDefaultHintsMap.containsKey('PostalCode'), true);
      });

      test('Keys have correct values', () {
        expect(formDefaultHintsMap['CardNumber'], 'Card Number');
        expect(formDefaultHintsMap['Expiration'], 'MM/YY');
        expect(formDefaultHintsMap['Cvv'], 'CVV');
        expect(formDefaultHintsMap['PostalCode'], 'Postal Code');
      });
    });

    group('Form Focused Default Hints:', () {
      test('Has correct length', () {
        expect(formFocusedDefaultHintsMap.length, 4);
      });

      test('Has correct keys', () {
        expect(formFocusedDefaultHintsMap.containsKey('CardNumber'), true);
        expect(formFocusedDefaultHintsMap.containsKey('Expiration'), true);
        expect(formFocusedDefaultHintsMap.containsKey('Cvv'), true);
        expect(formFocusedDefaultHintsMap.containsKey('PostalCode'), true);
      });

      test('Keys have correct values', () {
        expect(formFocusedDefaultHintsMap['CardNumber'], '');
        expect(formFocusedDefaultHintsMap['Expiration'], '');
        expect(formFocusedDefaultHintsMap['Cvv'], '');
        expect(formFocusedDefaultHintsMap['PostalCode'], '');
      });
    });

    group('isEqualTo():', () {
      test('All values equal, equality passes', () {
        const singleLineDefaults = Hints.singleLineDefaults;
        const singleLineHints = Hints.singleLineOnly();

        const formDefaults = Hints.formDefaults;
        const formHints = Hints.formOnly();

        const formFocusedDefaults = Hints.formFocusedDefaults;
        const formFocusedHints = Hints.formFocusedOnly();

        expect(singleLineDefaults.isEqualTo(singleLineHints), true);
        expect(singleLineHints.isEqualTo(singleLineDefaults), true);

        expect(formDefaults.isEqualTo(formHints), true);
        expect(formHints.isEqualTo(formDefaults), true);

        expect(formFocusedDefaults.isEqualTo(formFocusedHints), true);
        expect(formFocusedHints.isEqualTo(formFocusedDefaults), true);
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
