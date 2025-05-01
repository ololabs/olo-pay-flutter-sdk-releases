// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing the status of a line item
enum DigitalWalletLineItemStatus {
  /// Indicates that the price is final and has no variance
  finalStatus(stringValue: DataKeys.digitalWalletFinalStatus),

  /// Indicates that the price is pending and may change
  ///
  /// On iOS this will cause the amount to appear as an elipsis ("...")
  pendingStatus(stringValue: DataKeys.digitalWalletPendingStatus);

  /// Create a Digital Wallet Line Item Status
  const DigitalWalletLineItemStatus({required this.stringValue});

  /// The string value of the enum
  final String stringValue;

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
