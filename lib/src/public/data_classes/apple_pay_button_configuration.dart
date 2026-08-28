// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_style.dart';
import 'package:olo_pay_sdk/src/public/data_classes/apple_pay_button_type.dart';
import 'package:olo_pay_sdk/src/public/widgets/digital_wallet_button/digital_wallet_button.dart';

/// Parameters for configuring a [DigitalWalletButton] for use with Apple Pay
class ApplePayButtonConfiguration {
  /// The style to be used when displaying an Apple Pay button
  final ApplePayButtonStyle style;

  /// The type of Apple Pay button to display
  final ApplePayButtonType type;

  /// The radius, in points, for the rounded corners of the button
  final double cornerRadius;

  /// Create a new instance of this class
  const ApplePayButtonConfiguration({
    required this.style,
    required this.type,
    required this.cornerRadius,
  });

  /// Create an instance of this class by providing only the fields you want to
  /// customize
  ///
  /// If unspecified, [style] defaults to [ApplePayButtonStyle.black], [type]
  /// defaults to [ApplePayButtonType.checkout], and [cornerRadius] defaults to
  /// `8.0`
  const ApplePayButtonConfiguration.only({
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.checkout,
    this.cornerRadius = 8.0,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.applePayButtonStyleKey: style.stringValue,
      DataKeys.applePayButtonTypeKey: type.stringValue,
      DataKeys.applePayButtonCornerRadiusKey: cornerRadius,
    };
  }
}
