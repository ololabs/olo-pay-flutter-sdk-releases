// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';

/// Represents a payment method containing all information needed to submit a basket via Olo's Ordering API
class PaymentMethod {
  /// The payment method id.
  ///
  /// This should be set to the token field when submitting a basket
  final String id;

  /// The last four digits of the card
  final String last4;

  /// The issuer of the card
  ///
  /// **Important: When submitting this data to Olo's Ordering API, it is important to use [CardType.stringValue].
  /// Additionally, submitting a value of [CardType.unknown] or [CardType.unsupported] to Olo's ordering API will result in an error.
  final CardType cardType;

  /// The expiration month of the card
  final int expirationMonth;

  /// The expiration year of the card
  final int expirationYear;

  /// The zip/postal code of the card
  final String postalCode;

  /// The country associated with the card
  final String country;

  /// Whether or not this payment method is associated with a digital wallet
  final bool isDigitalWallet;

  /// Whether or not this payment method was created in the production environment
  final bool productionEnvironment;

  /// Create an instance of a payment method.
  ///
  /// **_Important:_** Other than for testing purposes, there should generally be no reason to create an instance of this class.
  const PaymentMethod({
    required this.id,
    required this.last4,
    required this.cardType,
    required this.expirationMonth,
    required this.expirationYear,
    required this.postalCode,
    required this.country,
    required this.isDigitalWallet,
    required this.productionEnvironment,
  });

  /// @nodoc
  @override
  String toString() {
    return '''
      id: $id
      last4: $last4
      cardType: $cardType
      expirationMonth: $expirationMonth
      expirationYear: $expirationYear
      postalCode: $postalCode
      country: $country
      isDigitalWallet: $isDigitalWallet
      productionEnvironment: $productionEnvironment
    ''';
  }
}
