// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representation of supported currency codes
enum CurrencyCode {
  /// United States Dollar
  usd(stringValue: DataKeys.usdCurrencyFieldValue),

  /// Canadian Dollar
  cad(stringValue: DataKeys.cadCurrencyFieldValue);

  /// The string value of the enum
  final String stringValue;

  /// @nodoc
  const CurrencyCode({required this.stringValue});

  /// @nodoc
  @override
  String toString() {
    return stringValue;
  }
}
