// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Parameters for initializing Apple Pay
class ApplePaySetupParameters {
  /// The merchant id registered with Apple for Apple Pay
  final String merchantId;

  /// The company name that will be displayed on the Apple Pay payment sheet
  final String companyLabel;

  /// Create a new instance of this class to configure Apple Pay
  const ApplePaySetupParameters({
    required this.merchantId,
    required this.companyLabel,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.applePayCompanyLabelParameterKey: companyLabel,
      DataKeys.applePayMerchantIdParameterKey: merchantId
    };
  }
}
