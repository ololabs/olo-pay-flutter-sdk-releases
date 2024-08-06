// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';

class CvvPage extends StatefulWidget {
  const CvvPage({
    super.key,
    required this.sdkInitialized,
  });

  final bool sdkInitialized;

  @override
  State<CvvPage> createState() => _CvvPageState();
}

class _CvvPageState extends State<CvvPage> {
  CvvTextFieldController? _cvvInputController;

  String _status = '';
  bool _enabled = true;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
  }

  void onCvvFieldControllerCreated(CvvTextFieldController controller) {
    _cvvInputController = controller;
  }

  void updateCvvUpdateToken(CvvUpdateToken cvvUpdateToken) {
    updateStatus("Cvv Update Token\n${cvvUpdateToken.toString()}");
  }

  void updateStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void onInputChanged(CardFieldState fieldState) {
    // log('onInputChanged:\n$fieldState');
  }

  void onValidStateChanged(CardFieldState fieldState) {
    // log('onValidStateChanged:\n$fieldState');
  }

  void onFocusChanged(CardFieldState fieldState) {
    // log('onFocusChanged:\n$fieldState');
  }

  Future<void> createCvvUpdateToken() async {
    try {
      var cvvUpdateToken = await _cvvInputController?.createCvvUpdateToken();
      if (cvvUpdateToken != null) {
        updateCvvUpdateToken(cvvUpdateToken);
      }
    } on PlatformException {
      // Handle CvvUpdateToken error here
    }
  }

  Future<void> getState() async {
    try {
      var state = await _cvvInputController?.getState();
      if (state != null) {
        var status = state.toString();
        updateStatus(status);
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> isValid() async {
    try {
      var valid = await _cvvInputController?.isValid();
      if (valid != null) {
        updateStatus("Is Valid: $valid");
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> isEnabled() async {
    if (_cvvInputController == null) {
      return;
    }

    var isEnabled = await _cvvInputController!.isEnabled();
    updateStatus("Enabled: $isEnabled");
  }

  Future<void> toggleEnabled() async {
    if (_cvvInputController == null) {
      return;
    }

    try {
      await _cvvInputController!.setEnabled(!_enabled);
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
      await _cvvInputController?.clear();
      updateStatus("");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> hasErrorMessage() async {
    if (_cvvInputController == null) {
      return;
    }

    try {
      var editedFieldError = await _cvvInputController?.hasErrorMessage();
      var uneditedFieldError = await _cvvInputController?.hasErrorMessage(
          ignoreUneditedField: false);

      updateStatus(
          "Has Error Message:\nEdited Field Error: $editedFieldError\nUnedited Field Error: $uneditedFieldError");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> getErrorMessage() async {
    if (_cvvInputController == null) {
      return;
    }

    try {
      var editedFieldError = await _cvvInputController?.getErrorMessage();
      var uneditedFieldError = await _cvvInputController?.getErrorMessage(
          ignoreUneditedField: false);

      updateStatus(
          "Error Message:\n\nEdited Field Error:\n$editedFieldError\nUnedited Field Error:\n$uneditedFieldError");
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> requestFocus() async {
    if (_cvvInputController == null) {
      return;
    }

    try {
      await _cvvInputController?.requestFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> clearFocus() async {
    if (_cvvInputController == null) {
      return;
    }

    try {
      await _cvvInputController?.clearFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("CVV Field"),
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
                const SizedBox(height: 20.0),
                if (widget
                    .sdkInitialized) //The SDK must be initialized prior to displaying the text field
                  CvvTextField(
                    onControllerCreated: onCvvFieldControllerCreated,
                    onFocusChanged: onFocusChanged,
                    onInputChanged: onInputChanged,
                    onValidStateChanged: onValidStateChanged,
                  ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: createCvvUpdateToken,
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
