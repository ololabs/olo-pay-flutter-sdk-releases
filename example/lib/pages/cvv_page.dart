// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:olo_pay_sdk_example/models/cvv_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/cvv_settings.dart';
import 'package:olo_pay_sdk_example/widgets/output_log.dart';
import 'package:olo_pay_sdk_example/widgets/page_widget.dart';
import 'package:olo_pay_sdk_example/widgets/payment_buttons.dart';
import 'package:olo_pay_sdk_example/widgets/settings_modal_bottomsheet.dart';
import 'package:provider/provider.dart';

class CvvPage extends StatefulWidget {
  const CvvPage({
    super.key,
    required this.sdkInitialized,
    required this.digitalWalletReady,
  });

  final bool sdkInitialized;
  final bool digitalWalletReady;

  @override
  State<CvvPage> createState() => _CvvPageState();
}

class _CvvPageState extends State<CvvPage> {
  CvvTextFieldController? _cvvInputController;

  String _status = '';
  CvvSettingsModel? _settingsModel;

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
    if (_settingsModel?.onInputChangedEnabled ?? false) {
      updateStatus('onInputChanged:\n$fieldState');
    }
  }

  void onValidStateChanged(CardFieldState fieldState) {
    if (_settingsModel?.onValidStateChangedEnabled ?? false) {
      updateStatus('onValidStateChanged:\n   isValid - ${fieldState.isValid}');
    }
  }

  void onFocusChanged(CardFieldState fieldState) {
    if (_settingsModel?.onFocusChangedEnabled ?? false) {
      updateStatus('onFocusChanged:\n   isFocused - ${fieldState.isFocused}');
    }
  }

  void onErrorMessageChanged(String errorMessage) {
    if (_settingsModel?.onErrorMessageChangedEnabled ?? false) {
      errorMessage.isEmpty
          ? updateStatus('onErrorMessageChanged:\n   No Error Message')
          : updateStatus(
              'onErrorMessageChanged:\n   errorMessage - $errorMessage',
            );
    }
  }

  void clearLog() {
    setState(() {
      updateStatus("");
    });
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
        ignoreUneditedField: false,
      );

      updateStatus(
        "Has Error Message:\nEdited Field Error: $editedFieldError\nUnedited Field Error: $uneditedFieldError",
      );
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
        ignoreUneditedField: false,
      );

      updateStatus(
        "Error Message:\n\nEdited Field Error:\n$editedFieldError\nUnedited Field Error:\n$uneditedFieldError",
      );
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

  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const SettingsModalBottomsheet(
        title: "CVV Settings",
        child: CvvSettings(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsModel = Provider.of<CvvSettingsModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: "CVV",
      onSettingsPressed: _showFullScreenModal,
      sdkInitialized: widget.sdkInitialized,
      digitalWalletReady: widget.digitalWalletReady,
      bodyContent: Column(
        children: <Widget>[
          if (widget
              .sdkInitialized) //The SDK must be initialized prior to displaying the text field
            CvvTextField(
              onControllerCreated: onCvvFieldControllerCreated,
              onFocusChanged: onFocusChanged,
              onInputChanged: onInputChanged,
              onValidStateChanged: onValidStateChanged,
              onErrorMessageChanged: onErrorMessageChanged,
              enabled: _settingsModel?.enabled ?? true,
              displayErrorMessages: _settingsModel?.showErrorMessages ?? true,
            ),
          PaymentButtonsWidget(
            createPaymentMethod: createCvvUpdateToken,
            clear: clear,
            buttonData: [
              {"label": "State", "onPressed": getState},
              {"label": "Is Valid?", "onPressed": isValid},
              {"label": "Enabled?", "onPressed": isEnabled},
              {"label": "Has Error?", "onPressed": hasErrorMessage},
              {"label": "Errors", "onPressed": getErrorMessage},
              {"label": "Focus", "onPressed": requestFocus},
              {"label": "Clear Focus", "onPressed": clearFocus},
            ],
          ),
        ],
      ),
      expandedContent: OutputLogWidget(logText: _status, clearLog: clearLog),
    );
  }
}
