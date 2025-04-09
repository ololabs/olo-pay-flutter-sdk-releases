// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/olo_pay_sdk_data_classes.dart';

void main() {
  final allParamsMap =
      DigitalWalletLineItem(
        amount: 1.20,
        type: DigitalWalletLineItemType.lineItem,
        label: "Item 1",
        status: DigitalWalletLineItemStatus.pendingStatus,
      ).toMap();

  final requiredParamsMap =
      DigitalWalletLineItem(
        amount: 2.34,
        type: DigitalWalletLineItemType.tax,
        label: "Item 2",
      ).toMap();

  final lineItemMap =
      DigitalWalletLineItem.lineItem(amount: 1.00, label: "Item 1").toMap();

  final subtotalParamsMap =
      DigitalWalletLineItem.subtotal(amount: 2.34).toMap();

  final taxParamsMap = DigitalWalletLineItem.tax(amount: 2.34).toMap();

  group('DigitalWalletLineItem', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(allParamsMap.containsKey('lineItemAmount'), true);
          expect(allParamsMap.containsKey('lineItemType'), true);
          expect(allParamsMap.containsKey('lineItemLabel'), true);
          expect(allParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['lineItemAmount'], 1.20);
          expect(allParamsMap['lineItemType'], 'LineItem');
          expect(allParamsMap['lineItemLabel'], 'Item 1');
          expect(allParamsMap['lineItemStatus'], 'Pending');
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('lineItemAmount'), true);
          expect(requiredParamsMap.containsKey('lineItemType'), true);
          expect(requiredParamsMap.containsKey('lineItemLabel'), true);
          expect(requiredParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['lineItemAmount'], 2.34);
          expect(requiredParamsMap['lineItemType'], 'Tax');
          expect(requiredParamsMap['lineItemLabel'], 'Item 2');
          expect(requiredParamsMap['lineItemStatus'], 'Final');
        });
      });

      group('Line Item type constructor:', () {
        test('Has correct length', () {
          expect(lineItemMap.length, 4);
        });
        test('Has correct keys', () {
          expect(lineItemMap.containsKey('lineItemAmount'), true);
          expect(lineItemMap.containsKey('lineItemType'), true);
          expect(lineItemMap.containsKey('lineItemLabel'), true);
          expect(lineItemMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(lineItemMap['lineItemAmount'], 1.00);
          expect(lineItemMap['lineItemType'], 'LineItem');
          expect(lineItemMap['lineItemLabel'], 'Item 1');
          expect(lineItemMap['lineItemStatus'], 'Final');
        });
      });

      group('Subtotal type constructor:', () {
        test('Has correct length', () {
          expect(subtotalParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(subtotalParamsMap.containsKey('lineItemAmount'), true);
          expect(subtotalParamsMap.containsKey('lineItemType'), true);
          expect(subtotalParamsMap.containsKey('lineItemLabel'), true);
          expect(subtotalParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(subtotalParamsMap['lineItemAmount'], 2.34);
          expect(subtotalParamsMap['lineItemType'], 'Subtotal');
          expect(subtotalParamsMap['lineItemLabel'], 'Subtotal');
          expect(subtotalParamsMap['lineItemStatus'], 'Final');
        });
      });

      group('Tax type constructor:', () {
        test('Has correct length', () {
          expect(taxParamsMap.length, 4);
        });
        test('Has correct keys', () {
          expect(taxParamsMap.containsKey('lineItemAmount'), true);
          expect(taxParamsMap.containsKey('lineItemType'), true);
          expect(taxParamsMap.containsKey('lineItemLabel'), true);
          expect(taxParamsMap.containsKey('lineItemStatus'), true);
        });

        test('Keys have correct values', () {
          expect(taxParamsMap['lineItemAmount'], 2.34);
          expect(taxParamsMap['lineItemType'], 'Tax');
          expect(taxParamsMap['lineItemLabel'], 'Tax');
          expect(taxParamsMap['lineItemStatus'], 'Final');
        });
      });
    });
  });
}
