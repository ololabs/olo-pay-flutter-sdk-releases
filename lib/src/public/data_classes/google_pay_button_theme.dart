// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing different visual styles available for a Google Pay button
///
/// Values map directly to Google's [ButtonTheme](https://developers.google.com/android/reference/com/google/android/gms/wallet/button/ButtonConstants.ButtonTheme)
enum GooglePayButtonTheme {
  // A light-themed button
  light(stringValue: DataKeys.googlePayButtonThemeLight),

  // A dark-themed button
  dark(stringValue: DataKeys.googlePayButtonThemeDark);

  /// @nodoc
  const GooglePayButtonTheme({required this.stringValue});

  /// The string value of this enum
  final String stringValue;
}
