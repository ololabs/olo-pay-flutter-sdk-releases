// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item_status.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item_type.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_payment_parameters.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_checkout_status.dart';

void main() {
  final allParamsMap =
      DigitalWalletPaymentParameters(
        amount: 1.20,
        googlePayCheckoutStatus: GooglePayCheckoutStatus.finalImmediatePurchase,
        totalPriceLabel: "Total Price",
        lineItems: [
          DigitalWalletLineItem(
            amount: 1.00,
            label: "Item 1",
            type: DigitalWalletLineItemType.lineItem,
            status: DigitalWalletLineItemStatus.pendingStatus,
          ),
          DigitalWalletLineItem(
            amount: 0.20,
            label: "Item 2",
            type: DigitalWalletLineItemType.tax,
            status: DigitalWalletLineItemStatus.finalStatus,
          ),
          DigitalWalletLineItem(
            amount: 1.20,
            type: DigitalWalletLineItemType.subtotal,
            label: "Subtotal",
            status: DigitalWalletLineItemStatus.finalStatus,
          ),
        ],
        validateLineItems: true,
      ).toMap();

  final requiredParamsMap = DigitalWalletPaymentParameters(amount: 234).toMap();

  group('DigitalWalletPaymentParameters:', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 5);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('amount'), true);
          expect(allParamsMap.containsKey('googlePayCheckoutStatus'), true);
          expect(allParamsMap.containsKey('totalPriceLabel'), true);
          expect(allParamsMap.containsKey('lineItems'), true);
          expect(allParamsMap.containsKey('validateLineItems'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['amount'], 1.20);
          expect(
            allParamsMap['googlePayCheckoutStatus'],
            'FinalImmediatePurchase',
          );
          expect(allParamsMap['totalPriceLabel'], 'Total Price');
          expect(allParamsMap['lineItems'], [
            {
              'lineItemAmount': 1.00,
              'lineItemLabel': 'Item 1',
              'lineItemType': 'LineItem',
              'lineItemStatus': 'Pending',
            },
            {
              'lineItemAmount': 0.20,
              'lineItemLabel': 'Item 2',
              'lineItemType': 'Tax',
              'lineItemStatus': 'Final',
            },
            {
              'lineItemAmount': 1.20,
              'lineItemLabel': 'Subtotal',
              'lineItemType': 'Subtotal',
              'lineItemStatus': 'Final',
            },
          ]);
          expect(allParamsMap['validateLineItems'], true);
        });
      });

      group('Required Params Only:', () {
        test('Has correct length', () {
          expect(requiredParamsMap.length, 5);
        });

        test('Has correct keys', () {
          expect(requiredParamsMap.containsKey('amount'), true);
          expect(
            requiredParamsMap.containsKey('googlePayCheckoutStatus'),
            true,
          );
          expect(requiredParamsMap.containsKey('totalPriceLabel'), true);
          expect(requiredParamsMap.containsKey('lineItems'), true);
          expect(requiredParamsMap.containsKey('validateLineItems'), true);
        });

        test('Keys have correct values', () {
          expect(requiredParamsMap['amount'], 234);
          expect(
            requiredParamsMap['googlePayCheckoutStatus'],
            'FinalImmediatePurchase',
          );
          expect(requiredParamsMap['totalPriceLabel'], null);
          expect(requiredParamsMap['lineItems'], null);
          expect(requiredParamsMap['validateLineItems'], true);
        });
      });
    });
  });
}
