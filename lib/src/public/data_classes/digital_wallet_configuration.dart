// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/currency_code.dart';

/// Configuration parameters for digital wallets.
class DigitalWalletConfiguration {
  /// The company display name
  ///
  /// This will usually show up in the Apple Pay / Google Pay sheet next to
  /// the total
  ///
  /// **Important:** For Google Pay, this name must match the name set in the
  /// Google Pay Business Console when setting up production access
  final String companyLabel;

  /// The currency used to process transactions
  ///
  /// Default value is [CurrencyCode.usd]
  final CurrencyCode currencyCode;

  /// A two character country code for the vendor that will be processing
  /// transactions
  ///
  /// Default value is "US"
  final String countryCode;

  /// Whether a full billing address will be collected and returned when
  /// processing transactions
  ///
  /// If `false`, only postal code and country code will be provided
  ///
  /// Default value is `false`
  final bool fullBillingAddressRequired;

  /// Whether Google Pay collects and returns an email address when processing
  /// payments
  ///
  /// Default value is `false`
  final bool emailRequired;

  /// Whether Google Pay collects and returns a phone number when processing
  /// transactions
  ///
  /// Default value is `false`
  final bool phoneNumberRequired;

  /// Whether Google Pay collects and returns a name when processing transactions
  ///
  /// Default value is `false`
  final bool fullNameRequired;

  /// Configuration parameters specific to Google Pay
  ///
  /// Required in order to use Google Pay
  final GooglePayConfiguration? googlePayConfig;

  /// Configuration parameters specific to Apple Pay
  ///
  /// Required in order to use Apple Pay
  final ApplePayConfiguration? applePayConfig;

  /// Create a new instance of this class to configure Google Pay
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [countryCode] : "US"
  /// - [currencyCode] : [CurrencyCode.usd]
  /// - [emailRequired] : `false`
  /// - [phoneNumberRequired] : `false`
  /// - [fullNameRequired] : `false`
  /// - [fullBillingAddressRequired] : `false`
  const DigitalWalletConfiguration({
    required this.companyLabel,
    this.countryCode = "US",
    this.currencyCode = CurrencyCode.usd,
    this.emailRequired = false,
    this.phoneNumberRequired = false,
    this.fullNameRequired = false,
    this.fullBillingAddressRequired = false,
    this.applePayConfig,
    this.googlePayConfig,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    Map<String, dynamic> dataMap = {
      DataKeys.digitalWalletCompanyLabelParameterKey: companyLabel,
      DataKeys.digitalWalletCountryCodeParameterKey: countryCode,
      DataKeys.digitalWalletCurrencyCodeKey: currencyCode.stringValue,
      DataKeys.googlePayEmailRequiredParameterKey: emailRequired,
      DataKeys.googlePayPhoneNumberRequiredParameterKey: phoneNumberRequired,
      DataKeys.googlePayFullNameRequiredParameterKey: fullNameRequired,
      DataKeys.googlePayFullBillingAddressRequiredParameterKey:
          fullBillingAddressRequired,
    };

    if (applePayConfig != null) {
      dataMap.addAll(applePayConfig!.toMap());
    }

    if (googlePayConfig != null) {
      dataMap.addAll(googlePayConfig!.toMap());
    }

    return dataMap;
  }
}
