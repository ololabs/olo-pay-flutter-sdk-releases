// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing different types of Google Pay buttons that can be used
///
/// Values map directly to Google's [ButtonType](https://developers.google.com/android/reference/com/google/android/gms/wallet/button/ButtonConstants.ButtonType)
enum GooglePayButtonType {
  /// A button that uses the phrase "Book with" in conjunction with the
  /// Google Pay logo
  book(stringValue: DataKeys.googlePayButtonTypeBook),

  /// A button that uses the phrase "Buy with" in conjunction with the
  /// Google Pay logo
  buy(stringValue: DataKeys.googlePayButtonTypeBuy),

  /// A button that uses the phrase "Checkout with" in conjunction with the
  /// Google Pay logo
  checkout(stringValue: DataKeys.googlePayButtonTypeCheckout),

  /// A button that uses the phrase "Donate with" in conjunction with the
  /// Google Pay logo
  donate(stringValue: DataKeys.googlePayButtonTypeDonate),

  /// A button that uses the phrase "Order with" in conjunction with the
  /// Google Pay logo
  order(stringValue: DataKeys.googlePayButtonTypeOrder),

  /// A button that uses the phrase "Pay with" in conjunction with the
  /// Google Pay logo
  pay(stringValue: DataKeys.googlePayButtonTypePay),

  /// A button with the Google Pay logo only
  plain(stringValue: DataKeys.googlePayButtonTypePlain),

  /// A button that uses the phrase "Subscribe with" in conjunction with the
  /// Google Pay logo
  subscribe(stringValue: DataKeys.googlePayButtonTypeSubscribe);

  /// @nodoc
  const GooglePayButtonType({required this.stringValue});

  /// The string value of this enum
  final String stringValue;
}
