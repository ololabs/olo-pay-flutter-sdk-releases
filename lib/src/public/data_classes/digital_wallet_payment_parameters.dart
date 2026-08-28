// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_checkout_status.dart';
import 'package:olo_pay_sdk/src/public/data_classes/digital_wallet_line_item.dart';
import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

/// Parameters used to create a digital wallet payment method
class DigitalWalletPaymentParameters {
  /// The amount to be charged
  final double amount;

  /// The status for the transaction. *(Android only)*
  ///
  /// For [GooglePayCheckoutStatus.finalImmediatePurchase], the pay button
  /// text in the Google Pay sheet will be "Pay Now". For other statuses it will say "Continue"
  final GooglePayCheckoutStatus googlePayCheckoutStatus;

  /// A custom value to override the default total price label in the Google Pay sheet *(Android only)*
  final String? totalPriceLabel;

  /// A list of line items to be displayed in the digital wallet payment sheet
  final List<DigitalWalletLineItem>? lineItems;

  /// Whether or not to validate the line items. If `true`, [OloPaySdk.createDigitalWalletPaymentMethod]
  /// will throw an exception if the sum of the line items does not equal the total amount passed in.
  /// If no line items are provided, this parameter is ignored.
  /// Default is `true`.
  final bool validateLineItems;

  /// Create digital wallet payment parameters
  DigitalWalletPaymentParameters({
    required this.amount,
    this.googlePayCheckoutStatus =
        GooglePayCheckoutStatus.finalImmediatePurchase,
    this.totalPriceLabel,
    this.lineItems,
    this.validateLineItems = true,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.digitalWalletAmountParameterKey: amount,
      DataKeys.googlePayCheckoutStatusKey: googlePayCheckoutStatus.toString(),
      DataKeys.digitalWalletTotalPriceLabelKey: totalPriceLabel,
      DataKeys.digitalWalletLineItemsKey:
          lineItems?.map((item) => item.toMap()).toList(),
      DataKeys.digitalWalletsValidateLineItemsKey: validateLineItems,
    };
  }
}
