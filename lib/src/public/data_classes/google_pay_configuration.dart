// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Configuration parameters for Google Pay transactions
class GooglePayConfiguration {
  /// Whether Google Pay will use the production environment
  ///
  /// Set to `true` to use the Google Pay production environment, `false` for
  /// the test environment. Before setting this to `true` Google will need to
  /// whitelist the app for production access.
  ///
  /// Default value is `true`
  final bool productionEnvironment;

  /// Multiplier to convert the amount to the currency's smallest unit
  ///
  /// Google Pay requires the amount to be specified in terms of the currency's smallest unit (e.g. pennies for USD).
  /// The Olo Pay SDK does that calculation for you. In most cases the currency multiplier is going to be 100, and
  /// is the default value if this property is not specified in the constructor.
  ///
  /// Example: $2.34 * 100 = 234 cents.
  ///
  /// Default value is `100`
  final int currencyMultiplier;

  /// Whether an existing saved payment method is required for Google Pay
  /// to be considered ready.
  ///
  /// Since cards can be added within the Google Pay sheet, it is recommended
  /// to set this to `false`
  ///
  /// Default value is `false`
  final bool existingPaymentMethodRequired;

  /// Create a new instance of this class to configure Google Pay
  ///
  /// Optional parameters will result in the following default values being used if not specified:
  /// - [productionEnvironment] : `true`
  /// - [currencyMultiplier] : 100
  /// - [existingPaymentMethodRequired] : `false`
  const GooglePayConfiguration({
    this.productionEnvironment = true,
    this.currencyMultiplier = 100,
    this.existingPaymentMethodRequired = false,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.googlePayProductionEnvironmentParameterKey:
          productionEnvironment,
      DataKeys.googlePayCurrencyMultiplierKey: currencyMultiplier,
      DataKeys.googlePayExistingPaymentMethodRequiredParameterKey:
          existingPaymentMethodRequired,
    };
  }
}
