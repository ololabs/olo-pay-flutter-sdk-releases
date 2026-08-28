// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing the different fields of a credit card
enum CardField {
  /// The card number field
  cardNumber(stringValue: DataKeys.cardNumberFieldValue),

  /// The expiration field
  expiration(stringValue: DataKeys.expirationFieldValue),

  /// The cvv field
  cvv(stringValue: DataKeys.cvvFieldValue),

  /// The postal code field
  postalCode(stringValue: DataKeys.postalCodeFieldValue);

  /// @nodoc
  const CardField({required this.stringValue});

  /// The string value of this enum
  final String stringValue;

  /// @nodoc
  static CardField? fromStringValue(String value) {
    switch (value) {
      case DataKeys.cardNumberFieldValue:
        return CardField.cardNumber;
      case DataKeys.expirationFieldValue:
        return CardField.expiration;
      case DataKeys.cvvFieldValue:
        return CardField.cvv;
      case DataKeys.postalCodeFieldValue:
        return CardField.postalCode;
      default:
        return null;
    }
  }

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
