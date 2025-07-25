// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_field_errors.dart';

/// Defines custom error messages for the widget
class CustomErrorMessages {
  /// Used to define empty and invalid error messages for the card number field
  final CustomFieldErrors? number;

  /// Used to define empty and invalid error messages for the card expiration field
  final CustomFieldErrors? expiration;

  /// Used to define empty and invalid error messages for the CVV field
  final CustomFieldErrors? cvv;

  /// Used to define empty and invalid error messages for the postal code field
  final CustomFieldErrors? postalCode;

  /// Custom error message for an unsupported card type
  ///
  /// Providing any string, including an empty string, will overwrite the default error.
  /// If this value is `null`, the default error will be used.
  final String? unsupportedCardError;

  /// Create custom error messages by providing values for each field
  const CustomErrorMessages({
    required this.number,
    required this.expiration,
    required this.cvv,
    required this.postalCode,
    required this.unsupportedCardError,
  });

  /// Create custom error messages for only the desired fields
  const CustomErrorMessages.only({
    this.number,
    this.expiration,
    this.cvv,
    this.postalCode,
    this.unsupportedCardError,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.cardNumberFieldValue: number?.toMap(),
      DataKeys.expirationFieldValue: expiration?.toMap(),
      DataKeys.cvvFieldValue: cvv?.toMap(),
      DataKeys.postalCodeFieldValue: postalCode?.toMap(),
      DataKeys.unsupportedCardError: unsupportedCardError,
    };
  }
}
