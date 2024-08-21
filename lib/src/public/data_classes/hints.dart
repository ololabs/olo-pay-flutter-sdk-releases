// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';

/// Defines the hint text for card input widget fields
class Hints {
  /// Hint for the card number field
  final String cardNumber;

  /// Hint for the expiration field
  final String expiration;

  /// Hint for the CVV field
  final String cvv;

  /// Hint for the postal code field
  final String postalCode;

  /// Convenience property for getting a [Hints] instance with all default values
  ///
  /// The defaults values are defined as follows:
  /// - [cardNumber] : "4242 4242 4242 4242"
  /// - [expiration] : "MM/YY"
  /// - [cvv] : "CVV"
  /// - [postalCode] : "Postal Code"
  static const Hints defaults = Hints.only();

  /// Create custom hints by providing values for each field
  const Hints({
    required this.cardNumber,
    required this.expiration,
    required this.cvv,
    required this.postalCode,
  });

  /// Create custom hints by providing values for only the fields you want to customize
  const Hints.only({
    this.cardNumber = Strings.defaultCardNumberHint,
    this.expiration = Strings.defaultExpirationHint,
    this.cvv = Strings.defaultCvvHint,
    this.postalCode = Strings.defaultPostalCodeHint,
  });

  /// @nodoc
  Map<String, String> toMap() {
    return {
      CardField.cardNumber.stringValue: cardNumber,
      CardField.expiration.stringValue: expiration,
      CardField.cvv.stringValue: cvv,
      CardField.postalCode.stringValue: postalCode,
    };
  }

  /// @nodoc
  bool isEqualTo(Hints? other) {
    return other != null &&
        cardNumber == other.cardNumber &&
        expiration == other.expiration &&
        cvv == other.cvv &&
        postalCode == other.postalCode;
  }
}
