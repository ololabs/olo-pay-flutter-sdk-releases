// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:pay/pay.dart';

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
  String _error = '';
  String _status = '';
  bool _digitalWalletsReady = false;
  bool _enabled = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _digitalWalletsReady = widget.digitalWalletReady;
    _oloPaySdkPlugin = widget.oloPaySdkPlugin;
  }

  void updateError(String error) {
    setState(() {
      _error = error;
    });
  }

  void updatePaymentMethod(PaymentMethod paymentMethod) {
    updateStatus("Payment Method\n${paymentMethod.toString()}");
  }

  void updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void onInputChanged(
      bool isValid, Map<CardField, CardFieldState> fieldStates) {
    // log('onInputChanged: $isValid');
  }

  void onValidStateChanged(
      bool isValid, Map<CardField, CardFieldState> fieldStates) {
    // log('onValidStateChanged: $isValid');
  }

  void onFocusChanged(CardField? focusedField, bool isValid,
      Map<CardField, CardFieldState> fieldStates) {
    // log('onFocusChanged: $focusedField');
  }

  void onDigitalWalletReady(bool isReady) {
    setState(() {
      _digitalWalletsReady = isReady;
    });
  }

  Future<void> createDigitalWalletPaymentMethod() async {
    const DigitalWalletPaymentParameters paymentParams =
        DigitalWalletPaymentParameters(
      amount: 1.21,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Digital Wallets"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    const Text(
                      "SDK Initialized:   ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.sdkInitialized.toString())
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Digital Wallets Ready:   ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_digitalWalletsReady.toString())
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    if (defaultTargetPlatform == TargetPlatform.android &&
                        _digitalWalletsReady)
                      Expanded(
                        child: RawGooglePayButton(
                          type: GooglePayButtonType.buy,
                          onPressed: createDigitalWalletPaymentMethod,
                        ),
                      ),
                    if (defaultTargetPlatform == TargetPlatform.iOS &&
                        _digitalWalletsReady)
                      Expanded(
                        child: RawApplePayButton(
                          type: ApplePayButtonType.buy,
                          onPressed: createDigitalWalletPaymentMethod,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
