// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

/// Parameters for initializing Google Pay
class GooglePaySetupParameters {
  /// A two character country code for the vendor that will be processing the payment
  ///
  /// This can be changed later via [OloPaySdk.changeGooglePayVendor]
  final String countryCode;

  /// The merchant/vendor display name
  ///
  /// This can be changed later via [OloPaySdk.changeGooglePayVendor]
  final String merchantName;

  /// Whether or not Google Pay will use the production environment
  ///
  /// Set to `true` to use the Google Pay production environment, `false` for the test environment. Defaults to `true`
  /// if not specified in the constructor.
  final bool productionEnvironment;

  /// Specify what fields are required to complete a Google Pay transaction
  ///
  /// `true` indicates all fields are required, which includes the following: name, street address, locality, region,
  /// country code, and postal code
  ///
  /// `false` includes only name, country code, and postal code
  ///
  /// Defaults to `false` if not specified in the constructor
  final bool fullAddressFormat;

  /// Whether or not an existing saved payment method is required for Google Pay to be considered ready
  ///
  /// Defaults to `true` if not specified in the constructor
  final bool existingPaymentMethodRequired;

  /// Whether Google Pay collects an email address when processing payments
  ///
  /// Defaults to `false` if not specified in the constructor
  final bool emailRequired;

  /// Whether Google Pay collects a phone number when processing payments
  ///
  /// Defaults to `false` if not specified in the constructor
  final bool phoneNumberRequired;

  /// Create a new instance of this class to configure Google Pay
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [productionEnvironment] : `true`
  /// - [fullAddressFormat] : `false`
  /// - [existingPaymentMethodRequired] : `true`
  /// - [emailRequired] : `false`
  /// - [phoneNumberRequired] : `false`
  const GooglePaySetupParameters({
    required this.countryCode,
    required this.merchantName,
    this.productionEnvironment = true,
    this.fullAddressFormat = false,
    this.existingPaymentMethodRequired = true,
    this.emailRequired = false,
    this.phoneNumberRequired = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.digitalWalletCountryCodeParameterKey: countryCode,
      DataKeys.googlePayMerchantNameParameterKey: merchantName,
      DataKeys.googlePayProductionEnvironmentParameterKey:
          productionEnvironment,
      DataKeys.googlePayFullAddressFormatParameterKey: fullAddressFormat,
      DataKeys.googlePayExistingPaymentMethodRequiredParameterKey:
          existingPaymentMethodRequired,
      DataKeys.googlePayEmailRequiredParameterKey: emailRequired,
      DataKeys.googlePayPhoneNumberRequiredParameterKey: phoneNumberRequired,
    };
  }
}
