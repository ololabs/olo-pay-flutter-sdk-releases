// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Enum representing different types of Apple Pay buttons that can be used
///
/// Values map directly to Apple's
/// [PKPaymentButtonType](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype)
enum ApplePayButtonType {
  /// A button with the Apple Pay logo only
  ///
  /// See Apple's documentation for [PKPaymentButtonType.plain](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/plain)
  /// for more information
  plain(stringValue: DataKeys.applePayButtonTypePlain),

  /// A button that uses the phrase "Buy with" in conjunction with the Apple Pay
  /// logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.buy](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/buy)
  /// for more information
  buy(stringValue: DataKeys.applePayButtonTypeBuy),

  /// A button that uses the phrase "Add Money with" in conjunction with the
  /// Apple Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.addMoney](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/addmoney)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  addMoney(stringValue: DataKeys.applePayButtonTypeAddMoney),

  /// A button that uses the phrase "Book with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.book](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/book)
  /// for more information
  book(stringValue: DataKeys.applePayButtonTypeBook),

  /// A button that uses the phrase "Check out with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.checkout](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/checkout)
  /// for more information
  checkout(stringValue: DataKeys.applePayButtonTypeCheckout),

  /// A button that uses the phrase "Continue with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.continue](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/continue)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 15+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  continueButton(stringValue: DataKeys.applePayButtonTypeContinue),

  /// A button that uses the phrase "Contribute with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.contribute](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/contribute)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  contribute(stringValue: DataKeys.applePayButtonTypeContribute),

  /// A button that uses the phrase "Donate with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.donate](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/donate)
  /// for more information
  donate(stringValue: DataKeys.applePayButtonTypeDonate),

  /// A button that uses the phrase "Pay with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.inStore](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/instore)
  /// for more information
  inStore(stringValue: DataKeys.applePayButtonTypeInStore),

  /// A button that uses the phrase "Pay with" in conjunction with the Apple
  /// Pay logo
  ///
  /// This is a convenience enum value equivalent to using
  /// [ApplePayButtonType.inStore]
  pay(stringValue: DataKeys.applePayButtonTypeInStore),

  /// A button that uses the phrase "Order with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.order](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/order)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  order(stringValue: DataKeys.applePayButtonTypeOrder),

  /// A button that uses the phrase "Reload with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.reload](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/reload)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  reload(stringValue: DataKeys.applePayButtonTypeReload),

  /// A button that uses the phrase "Rent with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.rent](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/rent)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  rent(stringValue: DataKeys.applePayButtonTypeRent),

  /// A button that uses the phrase "Set up" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.setUp](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/setup)
  /// for more information
  setup(stringValue: DataKeys.applePayButtonTypeSetUp),

  /// A button that uses the phrase "Subscribe with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.subscribe](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/subscribe)
  /// for more information
  subscribe(stringValue: DataKeys.applePayButtonTypeSubscribe),

  /// A button that uses the phrase "Support with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.support](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/support)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  support(stringValue: DataKeys.applePayButtonTypeSupport),

  /// A button that uses the phrase "Tip with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.tip](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/tip)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  tip(stringValue: DataKeys.applePayButtonTypeTip),

  /// A button that uses the phrase "Top Up with" in conjunction with the Apple
  /// Pay logo
  ///
  /// See Apple's documentation for [PKPaymentButtonType.topUp](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype/topup)
  /// for more information
  ///
  /// **IMPORTANT:** Only available on iOS 14+. If used on unsupported versions
  /// of iOS it will map to [ApplePayButtonType.checkout]
  topUp(stringValue: DataKeys.applePayButtonTypeTopUp);

  /// @nodoc
  const ApplePayButtonType({required this.stringValue});

  /// The string value of this enum
  final String stringValue;
}
