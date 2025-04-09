// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk_example/widgets/digital_wallet_settings.dart';
import 'package:olo_pay_sdk_example/widgets/line_items.dart';
import 'package:provider/provider.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:olo_pay_sdk_example/models/digital_wallet_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/output_log.dart';
import 'package:olo_pay_sdk_example/widgets/page_widget.dart';
import 'package:olo_pay_sdk_example/widgets/settings_modal_bottomsheet.dart';

class DigitalWalletsPage extends StatefulWidget {
  const DigitalWalletsPage({
    super.key,
    required this.sdkInitialized,
    required this.digitalWalletReady,
    required this.oloPaySdkPlugin,
  });

  final bool sdkInitialized;
  final bool digitalWalletReady;
  final OloPaySdk oloPaySdkPlugin;

  @override
  State<DigitalWalletsPage> createState() => _DigitalWalletsPageState();
}

class _DigitalWalletsPageState extends State<DigitalWalletsPage> {
  OloPaySdk? _oloPaySdkPlugin;
  String _status = '';
  bool _digitalWalletsReady = false;
  final double _amount = 11.23;
  double get _subtotal => (_total - _tax - _tip);
  double get _tax => double.parse((_amount * 0.1).toStringAsFixed(2));
  double get _tip => double.parse((_amount * 0.15).toStringAsFixed(2));
  double get _total => _amount;

  @override
  void initState() {
    super.initState();
    _digitalWalletsReady = widget.digitalWalletReady;
    _oloPaySdkPlugin = widget.oloPaySdkPlugin;
  }

  void updatePaymentMethod(PaymentMethod paymentMethod) {
    updateStatus("Payment Method\n${paymentMethod.toString()}");
  }

  void updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void onDigitalWalletReady(bool isReady) {
    setState(() {
      _digitalWalletsReady = isReady;
    });
  }

  void clearLog() {
    setState(() {
      updateStatus("");
    });
  }

  Future<void> createDigitalWalletPaymentMethod(
    bool usePayNowButton,
    bool useLineItems,
  ) async {
    DigitalWalletPaymentParameters paymentParams =
        DigitalWalletPaymentParameters(
          amount: _amount,
          googlePayCheckoutStatus:
              usePayNowButton
                  ? GooglePayCheckoutStatus.finalImmediatePurchase
                  : GooglePayCheckoutStatus.finalDefault,
          totalPriceLabel: useLineItems ? "Grand Total" : null,
          lineItems:
              useLineItems
                  ? [
                    DigitalWalletLineItem.subtotal(amount: _subtotal),
                    DigitalWalletLineItem.tax(amount: _tax),
                    DigitalWalletLineItem.lineItem(amount: _tip, label: "Tip"),
                  ]
                  : null,
        );

    try {
      PaymentMethod? paymentMethod = await _oloPaySdkPlugin
          ?.createDigitalWalletPaymentMethod(paymentParams);

      if (paymentMethod == null) {
        updateStatus("User Canceled");
      } else {
        updatePaymentMethod(paymentMethod);
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder:
          (ctx) => const SettingsModalBottomsheet(
            title: "Digital Wallet Settings",
            child: DigitalWalletSettings(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<DigitalWalletSettingsModel>(context);
    return PageWidget(
      title: "Digital Wallet",
      onSettingsPressed: _showFullScreenModal,
      sdkInitialized: widget.sdkInitialized,
      digitalWalletReady: widget.digitalWalletReady,
      bodyContent: Column(
        children: <Widget>[
          if (_digitalWalletsReady) //The SDK must be initialized prior to displaying the text field
            DigitalWalletButton(
              onClicked:
                  () => createDigitalWalletPaymentMethod(
                    settingsModel.usePayNowButton,
                    settingsModel.useLineItems,
                  ),
              enabled: settingsModel.enabled,
            ),
          if (_digitalWalletsReady && settingsModel.useLineItems) ...[
            const SizedBox(height: 6),
            LineItems(subtotal: _subtotal, tax: _tax, tip: _tip, total: _total),
          ],
        ],
      ),
      expandedContent: OutputLogWidget(logText: _status, clearLog: clearLog),
    );
  }
}
