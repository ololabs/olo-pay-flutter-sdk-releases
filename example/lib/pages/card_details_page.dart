// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({
    super.key,
    required this.sdkInitialized,
    required this.digitalWalletReady,
  });

  final bool sdkInitialized;
  final bool digitalWalletReady;

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  CardDetailsSingleLineTextFieldController? _cardInputController;

  String _status = '';
  bool _enabled = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
  }

  void onSingleLineControllerCreated(
      CardDetailsSingleLineTextFieldController controller) {
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

  Future<void> createPaymentMethod() async {
    try {
      var paymentMethod = await _cardInputController?.createPaymentMethod();
      if (paymentMethod != null) {
        updatePaymentMethod(paymentMethod);
      }
    } on PlatformException {
      // Handle PaymentMethod error here
    }
  }

  Future<void> getState() async {
    try {
      var state = await _cardInputController?.getState();
      if (state != null) {
        var status = state.entries
            .map<String>((e) => "${e.key}\n${e.value.toString()}\n")
            .reduce((value, element) => value + element);
        updateStatus(status);
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> isValid() async {
    try {
      var valid = await _cardInputController?.isValid();
      if (valid != null) {
        updateStatus("Is Valid: $valid");
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> getCardType() async {
    try {
      var cardType = await _cardInputController?.getCardType();
      if (cardType != null) {
        updateStatus("Card Type: ${cardType.stringValue}");
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> isEnabled() async {
    if (_cardInputController == null) {
      return;
    }

    var isEnabled = await _cardInputController!.isEnabled();
    updateStatus("Enabled: $isEnabled");
  }

  Future<void> toggleEnabled() async {
    if (_cardInputController == null) {
      return;
    }

    try {
      await _cardInputController!.setEnabled(!_enabled);
      setState(() {
        _enabled = !_enabled;
        updateStatus("Enabled: $_enabled");
      });
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

  Future<void> hasErrorMessage() async {
    if (_cardInputController == null) {
      return;
    }

    try {
      var editedFieldsError = await _cardInputController?.hasErrorMessage();
      var uneditedFieldsError = await _cardInputController?.hasErrorMessage(
          ignoreUneditedFields: false);

      updateStatus(
          "Has Error Message:\nEdited Fields Only: $editedFieldsError\nAll Fields: $uneditedFieldsError");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> getErrorMessage() async {
    if (_cardInputController == null) {
      return;
    }

    try {
      var editedFieldsError = await _cardInputController?.getErrorMessage();
      var uneditedFieldsError = await _cardInputController?.getErrorMessage(
          ignoreUneditedFields: false);

      updateStatus(
          "Error Message:\n\nEdited Fields Only:\n$editedFieldsError\nAll Fields:\n$uneditedFieldsError");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> requestFocus() async {
    if (_cardInputController == null) {
      return;
    }

    try {
      await _cardInputController?.requestFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> clearFocus() async {
    if (_cardInputController == null) {
      return;
    }

    try {
      await _cardInputController?.clearFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Card Controls"),
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
                    Text(widget.digitalWalletReady.toString())
                  ],
                ),
                const SizedBox(height: 20.0),
                if (widget
                    .sdkInitialized) //The SDK must be initialized prior to displaying the text field
                  CardDetailsSingleLineTextField(
                    onControllerCreated: onSingleLineControllerCreated,
                    onInputChanged: onInputChanged,
                    onValidStateChanged: onValidStateChanged,
                    onFocusChanged: onFocusChanged,
                  ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: createPaymentMethod,
                      child: const Text("Submit"),
                    ),
                    ElevatedButton(
                      onPressed: clear,
                      child: const Text("Clear"),
                    ),
                    TextButton.icon(
                      icon: Text(_showAll ? "Show Less" : "Show More"),
                      label: Icon(
                        _showAll
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 24.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _showAll = !_showAll;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                if (_showAll)
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 3,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      ElevatedButton(
                        onPressed: getState,
                        child: const Text("State"),
                      ),
                      ElevatedButton(
                        onPressed: isValid,
                        child: const Text("Is Valid?"),
                      ),
                      ElevatedButton(
                        onPressed: getCardType,
                        child: const Text("Card Type"),
                      ),
                      ElevatedButton(
                        onPressed: isEnabled,
                        child: const Text("Enabled?"),
                      ),
                      ElevatedButton(
                        onPressed: hasErrorMessage,
                        child: const Text("Has Error?"),
                      ),
                      ElevatedButton(
                        onPressed: getErrorMessage,
                        child: const Text("Errors"),
                      ),
                      ElevatedButton(
                        onPressed: requestFocus,
                        child: const Text("Focus"),
                      ),
                      ElevatedButton(
                        onPressed: clearFocus,
                        child: const Text("Clear Focus"),
                      ),
                      TextButton.icon(
                        icon: const Text("Enable"),
                        label: Icon(
                          _enabled
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          size: 24.0,
                        ),
                        onPressed: toggleEnabled,
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
