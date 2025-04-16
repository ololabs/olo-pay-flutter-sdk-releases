// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/address.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_configuration.dart';

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

  /// The country code associated with the card
  final String countryCode;

  /// The description of the card, as provided by Apple or Google.
  ///
  /// Only available for digital wallet payment methods (see [isDigitalWallet]). For other payment methods, this property will be an empty string.
  final String digitalWalletCardDescription;

  /// The email address associated with the transaction, or an empty string if unavailable.
  ///
  /// Will only be provided for digital payment methods (see [isDigitalWallet]) with [DigitalWalletConfiguration.emailRequired] set to true.
  final String email;

  /// The phone number associated with the transaction, or an empty string if unavailable.
  ///
  /// Will only be provided for digital wallet payment methods (see [isDigitalWallet]) with [DigitalWalletConfiguration.phoneNumberRequired] set to true
  final String phoneNumber;

  /// The full name associated with the transaction, or an empty string if unavailable.
  ///
  /// Will only be provided for digital wallet payment methods (see [isDigitalWallet]) with [DigitalWalletConfiguration.fullNameRequired] set to true.
  final String fullName;

  /// The billing address associated with the transaction. The country code and postal code fields will always be set.
  ///
  /// Other fields will only be set for digital wallet payment methods (see [isDigitalWallet]) with [DigitalWalletConfiguration.fullBillingAddressRequired] set to true
  final Address billingAddress;

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
    required this.countryCode,
    required this.digitalWalletCardDescription,
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.billingAddress,
    required this.isDigitalWallet,
    required this.productionEnvironment,
  });

  factory PaymentMethod.fromMap(Map<dynamic, dynamic> map) {
    return PaymentMethod(
      id: map[DataKeys.pmIdKey],
      last4: map[DataKeys.pmLast4Key],
      cardType: CardType.fromStringValue(map[DataKeys.pmCardTypeKey]),
      expirationMonth: map[DataKeys.pmExpirationMonthKey],
      expirationYear: map[DataKeys.pmExpirationYearKey],
      postalCode: map[DataKeys.pmPostalCodeKey],
      countryCode: map[DataKeys.pmCountryCodeKey],
      digitalWalletCardDescription:
          map[DataKeys.pmDigitalWalletCardDescriptionKey],
      email: map[DataKeys.pmEmailKey],
      phoneNumber: map[DataKeys.pmPhoneNumberKey],
      fullName: map[DataKeys.pmFullNameKey],
      billingAddress: Address.fromMap(map[DataKeys.pmBillingAddressKey]),
      isDigitalWallet: map[DataKeys.pmIsDigitalWalletKey],
      productionEnvironment: map[DataKeys.productionEnvironmentKey],
    );
  }

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
      countryCode: $countryCode
      digitalWalletCardDescription: $digitalWalletCardDescription
      email: $email
      phoneNumber: $phoneNumber
      fullName: $fullName
      billingAddress: $billingAddress
      isDigitalWallet: $isDigitalWallet
      productionEnvironment: $productionEnvironment
    ''';
  }
}
