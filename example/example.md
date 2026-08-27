```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:pay/pay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Olo Pay SDK Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(1, 160, 219, 1)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Step 1: Create the plugin instance
  final _oloPaySdkPlugin = OloPaySdk();

  // Controller classes allow interaction with the widget
  CardDetailsSingleLineTextFieldController? _cardInputController;

  String _status = '';
  bool _sdkInitialized = false;
  bool _digitalWalletsReady = false;
  bool _enabled = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    initOloPaySDK();
  }

  void onSingleLineControllerCreated(CardDetailsSingleLineTextFieldController controller) {
    _cardInputController = controller;
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
    bool isValid, Map<CardField,
    CardFieldState> fieldStates,
  ) {
    // Add code here to handle this callback
    // log('onInputChanged: $isValid');
  }

  void onValidStateChanged(
    bool isValid, Map<CardField,
    CardFieldState> fieldStates,
  ) {
    // Add code here to handle this callback
    // log('onValidStateChanged: $isValid');
  }

  void onFocusChanged(
    CardField? focusedField,
    bool isValid,
    Map<CardField, CardFieldState> fieldStates,
  ) {
    // Add code here to handle this callback
    // log('onFocusChanged: $focusedField');
  }

  void onDigitalWalletReady(bool isReady) {
    setState(() {
      _digitalWalletsReady = isReady;
    });
  }

  // Step 2: Initialize the Olo Pay SDK
  Future<void> initOloPaySDK() async {
    var sdkInitialized = false;
    try {
      _oloPaySdkPlugin.onDigitalWalletReady = onDigitalWalletReady;

      await _oloPaySdkPlugin.initializeOloPay(
        productionEnvironment: false,
        digitalWalletConfig: const DigitalWalletConfiguration(
          companyLabel: "Company Name",
          applePayConfig: ApplePayConfiguration(
            merchantId: "merchant.com.company.merchant.id",
          ),
          googlePayConfig: GooglePayConfiguration(
            productionEnvironment: false,
          ),
        ),
      );
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }

    setState(() {
      _sdkInitialized = true;
    });
  }

  Future<void> createPaymentMethod() async {
    try {
      var paymentMethod = await _cardInputController?.createPaymentMethod();
      if (paymentMethod != null) {
        // Once a payment method is generated, it can be used to submit an order to the Olo Ordering API
        updatePaymentMethod(paymentMethod);
      }
    } on PlatformException {
      // Handle exceptions here
    }
  }

  Future<void> createDigitalWalletPaymentMethod() async {
    const DigitalWalletPaymentParameters paymentParams = DigitalWalletPaymentParameters(amount: 1.21);

    try {
      PaymentMethod? paymentMethod = await _oloPaySdkPlugin
          .createDigitalWalletPaymentMethod(paymentParams);

      if (paymentMethod == null) {
        // User canceled digital wallet flow
        updateStatus("User Canceled");
      } else {
        // Once a payment method is generated, it can be used to submit an order to the Olo Ordering API
        updatePaymentMethod(paymentMethod);
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> clear() async {
    try {
      await _cardInputController?.clearFields();
      updateStatus("");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Olo Pay SDK Demo"),
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
                    Text(_sdkInitialized.toString())
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
                const SizedBox(height: 16.0),
                if (_sdkInitialized) //The SDK must be initialized prior to displaying the text field
                  CardDetailsSingleLineTextField(
                    // Step 3: Provide a callback to get a controller instance
                    onControllerCreated: onSingleLineControllerCreated,
                    onInputChanged: onInputChanged,
                    onValidStateChanged: onValidStateChanged,
                    onFocusChanged: onFocusChanged,
                  ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      // Step 4a: Create the payment method with a card input widget
                      onPressed: createPaymentMethod,
                      child: const Text("Submit"),
                    ),
                    ElevatedButton(
                      onPressed: clear,
                      child: const Text("Clear"),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    if (defaultTargetPlatform == TargetPlatform.android &&
                        _digitalWalletsReady)
                      Expanded(
                        child: RawGooglePayButton(
                          type: GooglePayButtonType.buy,
                          // Step 4b: Create the payment method via Google Pay
                          onPressed: createDigitalWalletPaymentMethod,
                        ),
                      ),
                    if (defaultTargetPlatform == TargetPlatform.iOS &&
                        _digitalWalletsReady)
                      Expanded(
                        child: RawApplePayButton(
                          type: ApplePayButtonType.buy,
                          // Step 4c: Create the payment method via Apple Pay 
                          onPressed: createDigitalWalletPaymentMethod,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8.0),
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
```