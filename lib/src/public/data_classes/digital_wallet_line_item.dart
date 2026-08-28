// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item_status.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item_type.dart';

/// Represents a line item in a digital wallet transaction
class DigitalWalletLineItem {
  /// The amount of the line item
  final double amount;

  /// The type of the line item
  final DigitalWalletLineItemType type;

  /// The label of the line item
  final String label;

  /// The status of the line item
  ///
  /// Defaults to [DigitalWalletLineItemStatus.finalStatus]
  final DigitalWalletLineItemStatus status;

  /// Create a digital wallet line item
  ///
  /// If not specified, optional parameter [status] defaults to [DigitalWalletLineItemStatus.finalStatus]
  DigitalWalletLineItem({
    required this.amount,
    required this.type,
    required this.label,
    this.status = DigitalWalletLineItemStatus.finalStatus,
  });

  /// Convenience constructor for a line item of type [DigitalWalletLineItemType.lineItem]
  ///
  /// If not specified, optional parameter [status] defaults to [DigitalWalletLineItemStatus.finalStatus]
  factory DigitalWalletLineItem.lineItem({
    required double amount,
    required String label,
    DigitalWalletLineItemStatus status =
        DigitalWalletLineItemStatus.finalStatus,
  }) {
    return DigitalWalletLineItem(
      amount: amount,
      type: DigitalWalletLineItemType.lineItem,
      label: label,
      status: status,
    );
  }

  /// Convenience constructor for a line item of type [DigitalWalletLineItemType.subtotal]
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [label] : "Subtotal"
  /// - [status] : [DigitalWalletLineItemStatus.finalStatus]
  factory DigitalWalletLineItem.subtotal({
    required double amount,
    String label = DataKeys.digitalWalletLineItemSubtotalLabelKey,
    DigitalWalletLineItemStatus status =
        DigitalWalletLineItemStatus.finalStatus,
  }) {
    return DigitalWalletLineItem(
      amount: amount,
      type: DigitalWalletLineItemType.subtotal,
      label: label,
      status: status,
    );
  }

  /// Convenience constructor for a line item of type [DigitalWalletLineItemType.tax]
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [label] : "Tax"
  /// - [status] : [DigitalWalletLineItemStatus.finalStatus]
  factory DigitalWalletLineItem.tax({
    required double amount,
    String label = DataKeys.digitalWalletLineItemTaxLabelKey,
    DigitalWalletLineItemStatus status =
        DigitalWalletLineItemStatus.finalStatus,
  }) {
    return DigitalWalletLineItem(
      amount: amount,
      type: DigitalWalletLineItemType.tax,
      label: label,
      status: status,
    );
  }

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.digitalWalletLineItemAmountKey: amount,
      DataKeys.digitalWalletLineItemTypeKey: type.stringValue,
      DataKeys.digitalWalletLineItemLabelKey: label,
      DataKeys.digitalWalletLineItemStatusKey: status.stringValue,
    };
  }
}
