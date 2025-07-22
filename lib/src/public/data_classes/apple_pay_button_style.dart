// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing different visual styles available for an Apple Pay button
///
/// Values map directly to Apple's
/// [PKPaymentButtonStyle](https://developer.apple.com/documentation/PassKit/PKPaymentButtonStyle)
enum ApplePayButtonStyle {
  /// A white button with black lettering.
  ///
  /// See Apple's documentation for [PKPaymentButtonStyle.white](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle/white)
  /// for more information
  white(stringValue: DataKeys.applePayButtonStyleWhite),

  /// A white button with black lettering and a black outline
  ///
  /// See Apple's documentatation for [PKPaymentButtonStyle.whiteOutline](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle/whiteoutline)
  /// for more information
  whiteOutline(stringValue: DataKeys.applePayButtonStyleWhiteOutline),

  /// A black button with white lettering
  ///
  /// See Apple's documentatation for [PKPaymentButtonStyle.black](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle/black)
  /// for more information
  black(stringValue: DataKeys.applePayButtonStyleBlack),

  /// A button that automatically switches between light mode and dark mode
  ///
  /// See Apple's documentation for [PKPaymentButtonStyle.automatic](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle/automatic)
  /// for more information.
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonStyle.black]
  automatic(stringValue: DataKeys.applePayButtonStyleAutomatic);

  /// @nodoc
  const ApplePayButtonStyle({required this.stringValue});

  /// The string value of this enum
  final String stringValue;
}
