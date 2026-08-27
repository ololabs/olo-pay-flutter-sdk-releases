// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing valid checkout option and price status combinations, as defined by Google.
///
/// For more details, see the totalPriceStatus and checkoutOption properties of Google's [TransactionInfo object](https://developers.google.com/pay/api/web/reference/request-objects#TransactionInfo).
enum GooglePayCheckoutStatus {
  /// Represents an estimated price (meaning it's not final and could change) and the default checkout option.
  /// The confirmation button will display "Continue".
  estimatedDefault(stringValue: DataKeys.estimatedDefault),

  /// Represents the final price of the transaction and the default checkout option.
  /// The confirmation button will display "Continue".
  finalDefault(stringValue: DataKeys.finalDefault),

  /// Represents the final price of the transaction and the immediate checkout option.
  /// The confirmation button will display "Pay Now".
  finalImmediatePurchase(stringValue: DataKeys.finalImmediatePurchase);

  /// The string value of the enum.
  final String stringValue;

  /// @nodoc
  const GooglePayCheckoutStatus({required this.stringValue});

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
