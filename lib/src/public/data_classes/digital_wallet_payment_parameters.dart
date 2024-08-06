// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

/// Parameters used to create a digital wallet payment method
///
/// **Important:** Some properties are platform-specific, but it is safe to pass them to both platforms. Refer to each
/// property to ensure these parameters are set up properly for your use case.
class DigitalWalletPaymentParameters {
  /// The amount to be charged
  final double amount;

  /// **_(Android Only)_** Multiplier to convert the amount to the currency's smallest unit
  ///
  /// Google Pay requires the amount to be specified in terms of the currency's smallest unit (e.g. pennies for USD).
  /// The Olo Pay SDK does that calculation for you. In most cases the currency multiplier is going to be 100, and
  /// is the default value if this property is not specified in the constructor.
  ///
  /// Example: $2.34 * 100 = 234 cents.
  ///
  /// **Important:** This property is ignored on iOS
  final int currencyMultiplier;

  /// A three character currency code for the transaction (e.g. "USD")
  ///
  /// If this property is not specified in the contstructor, "USD" will be used as the default
  final String currencyCode;

  /// **_(iOS Only)_** A two character country code representing the country of the vendor
  ///
  /// This property is only needed for iOS because it is provided for Android when Google Pay is initialized. To change
  /// the country code used by Google Pay, please see [OloPaySdk.changeGooglePayVendor]. If not specified in the
  /// constructor, "US" will be used as the default.
  ///
  /// **Important:** This property is ignored on Android
  final String countryCode;

  /// Create digital wallet payment parameters
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [currencyCode] : "USD"
  /// - [currencyMultiplier] : 100
  /// - [countryCode] : "US"
  const DigitalWalletPaymentParameters({
    required this.amount,
    this.currencyCode = "USD",
    this.currencyMultiplier = 100,
    this.countryCode = "US",
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.digitalWalletAmountParameterKey: amount,
      DataKeys.digitalWalletCountryCodeParameterKey: countryCode,
      DataKeys.digitalWalletCurrencyCodeKey: currencyCode,
      DataKeys.googlePayCurrencyMultiplierKey: currencyMultiplier
    };
  }
}
