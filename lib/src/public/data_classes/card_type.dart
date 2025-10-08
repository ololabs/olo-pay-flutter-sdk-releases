// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing credit card types
///
/// **_Important:_** When submitting card details to Olo's ordering API
/// the card type value passed should be the [stringValue] of this enum.
enum CardType {
  /// Visa
  visa(stringValue: DataKeys.visaFieldValue),

  /// American Express
  americanExpress(stringValue: DataKeys.amexFieldValue),

  /// Discover
  discover(stringValue: DataKeys.discoverFieldValue),

  /// Mastercard
  masterCard(stringValue: DataKeys.masterCardFieldValue),

  /// Unsupported: The card brand is not supported by Olo Pay
  unsupported(stringValue: DataKeys.unsupportedCardFieldValue),

  /// Unknown: The card brand could not be determined
  unknown(stringValue: DataKeys.unknownCardFieldValue);

  /// The string value of the enum.
  ///
  /// This is the value that should be used when submitting card data to Olo's Ordering API.
  final String stringValue;

  /// @nodoc
  const CardType({required this.stringValue});

  /// @nodoc
  static CardType fromStringValue(String? stringValue) {
    switch (stringValue) {
      case DataKeys.visaFieldValue:
        return CardType.visa;
      case DataKeys.amexFieldValue:
        return CardType.americanExpress;
      case DataKeys.discoverFieldValue:
        return CardType.discover;
      case DataKeys.masterCardFieldValue:
        return CardType.masterCard;
      case DataKeys.unsupportedCardFieldValue:
        return CardType.unsupported;
      default:
        return CardType.unknown;
    }
  }

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
