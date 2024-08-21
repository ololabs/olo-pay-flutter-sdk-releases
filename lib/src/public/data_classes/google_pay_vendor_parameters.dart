// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Parameters for specificying a new vendor for Google Pay
class GooglePayVendorParameters {
  /// A two character country code representing the country of the vendor
  final String countryCode;

  /// The merchant/vendor display name
  final String merchantName;

  /// Create a new instance of this class to specify new Google Pay vendor settings
  const GooglePayVendorParameters({
    required this.countryCode,
    required this.merchantName,
  });

  /// @nodoc
  Map<String, String> toMap() {
    return {
      DataKeys.digitalWalletCountryCodeParameterKey: countryCode,
      DataKeys.googlePayMerchantNameParameterKey: merchantName,
    };
  }
}
