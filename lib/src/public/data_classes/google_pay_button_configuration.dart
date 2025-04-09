// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_theme.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_button_type.dart';
import 'package:olo_pay_sdk/src/public/widgets/digital_wallet_button/digital_wallet_button.dart';

/// Parameters for configuring a [DigitalWalletButton] for use with Google Pay
class GooglePayButtonConfiguration {
  /// The theme to be used when display a Google Pay button
  final GooglePayButtonTheme theme;

  /// The type of Google Pay button to display
  final GooglePayButtonType type;

  /// The corner radius, in dp units, for the rounded corners of the button
  final double cornerRadius;

  /// Create a new instance of this class
  const GooglePayButtonConfiguration({
    required this.theme,
    required this.type,
    required this.cornerRadius,
  });

  /// Create an instance of this class by providing only the fields you want to
  /// customize
  ///
  /// If unspecified, [theme] defaults to [GooglePayButtonTheme.dark], [type]
  /// defaults to [GooglePayButtonType.checkout], and [cornerRadius] defaults to
  /// `8.0`
  const GooglePayButtonConfiguration.only({
    this.theme = GooglePayButtonTheme.dark,
    this.type = GooglePayButtonType.checkout,
    this.cornerRadius = 8.0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.googlePayButtonThemeKey: theme.stringValue,
      DataKeys.googlePayButtonTypeKey: type.stringValue,
      DataKeys.googlePayButtonCornerRadiusKey: cornerRadius,
    };
  }
}
