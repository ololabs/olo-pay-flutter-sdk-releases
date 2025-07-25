// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Parameters for initializing Apple Pay
class ApplePayConfiguration {
  /// The merchant id registered with Apple for Apple Pay
  final String merchantId;

  /// Whether the full phonetic name is required for Apple Pay transactions
  final bool fullPhoneticNameRequired;

  /// Create a new instance of this class to configure Apple Pay
  const ApplePayConfiguration(
      {required this.merchantId, this.fullPhoneticNameRequired = false});

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.applePayMerchantIdParameterKey: merchantId,
      DataKeys.applePayFullPhoneticNameRequiredParameterKey:
          fullPhoneticNameRequired
    };
  }
}
