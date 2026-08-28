// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk.dart';
import 'package:olo_pay_sdk_example/models/single_line_view_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/card_details_settings.dart';
import 'package:olo_pay_sdk_example/widgets/output_log.dart';
import 'package:olo_pay_sdk_example/widgets/page_widget.dart';
import 'package:olo_pay_sdk_example/widgets/payment_buttons.dart';
import 'package:olo_pay_sdk_example/widgets/settings_modal_bottomsheet.dart';
import 'package:provider/provider.dart';

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
  CardDetailsFormTextFieldController? _formInputController;

  String _status = '';
  CardDetailsSettingsModel? _settingsModel;
  bool _isSingleLineView = true;
  bool get bothControllersNull =>
      _cardInputController == null && _formInputController == null;

  @override
  void initState() {
    super.initState();
  }

  void onSingleLineControllerCreated(
    CardDetailsSingleLineTextFieldController controller,
  ) {
    _cardInputController = controller;
  }

  void onFormControllerCreated(CardDetailsFormTextFieldController controller) {
    _formInputController = controller;
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
    bool isValid,
    Map<CardField, CardFieldState> fieldStates,
  ) {
    if (_settingsModel?.onInputChangedEnabled ?? false) {
      updateStatus(
        'onInputChanged: \n isValid - $isValid \n fieldStates - \n$fieldStates.cardField',
      );
    }
  }

  void onFormValidStateChanged(bool isValid) {
    if (_settingsModel?.onValidStateChangedEnabled ?? false) {
      updateStatus('onValidStateChanged: $isValid');
    }
  }

  void onValidStateChanged(
    bool isValid,
    Map<CardField, CardFieldState> fieldStates,
  ) {
    if (_settingsModel?.onValidStateChangedEnabled ?? false) {
      updateStatus(
        'onValidStateChanged: \n isValid - $isValid\n fieldStates - \n$fieldStates',
      );
    }
  }

  void onFocusChanged(
    CardField? focusedField,
    bool isValid,
    Map<CardField, CardFieldState> fieldStates,
  ) {
    if (_settingsModel?.onFocusChangedEnabled ?? false) {
      updateStatus(
        'onFocusChanged: \n focusedField - $focusedField\n isValid - $isValid\n fieldStates - \n$fieldStates',
      );
    }
  }

  void onErrorMessagedChanged(String errorMessage) {
    if (_settingsModel?.onErrorMessageChangedEnabled ?? false) {
      errorMessage.isEmpty
          ? updateStatus('onErrorMessageChanged: \n No Error Message')
          : updateStatus(
              'onErrorMessageChanged: \n errorMessage - $errorMessage',
            );
    }
  }

  void clearLog() {
    setState(() {
      updateStatus("");
    });
  }

  Future<void> createPaymentMethod() async {
    if (bothControllersNull) {
      return;
    }

    try {
      var paymentMethod = _isSingleLineView
          ? await _cardInputController?.createPaymentMethod()
          : await _formInputController?.createPaymentMethod();
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
      var valid = _isSingleLineView
          ? await _cardInputController?.isValid()
          : await _formInputController?.isValid();
      if (valid != null) {
        updateStatus("Is Valid: $valid");
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> getCardType() async {
    if (bothControllersNull) {
      return;
    }

    try {
      var cardType = _isSingleLineView
          ? await _cardInputController?.getCardType()
          : await _formInputController?.getCardType();
      if (cardType != null) {
        updateStatus("Card Type: ${cardType.stringValue}");
      }
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> isEnabled() async {
    if (bothControllersNull) {
      return;
    }

    var isEnabled = _isSingleLineView
        ? await _cardInputController!.isEnabled()
        : await _formInputController!.isEnabled();
    updateStatus("Enabled: $isEnabled");
  }

  Future<void> clear() async {
    if (bothControllersNull) {
      return;
    }

    try {
      _isSingleLineView
          ? await _cardInputController?.clearFields()
          : await _formInputController?.clearFields();
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
        ignoreUneditedFields: false,
      );

      updateStatus(
        "Has Error Message:\nEdited Fields Only: $editedFieldsError\nAll Fields: $uneditedFieldsError",
      );
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
        ignoreUneditedFields: false,
      );

      updateStatus(
        "Error Message:\n\nEdited Fields Only:\n$editedFieldsError\nAll Fields:\n$uneditedFieldsError",
      );
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> requestFocus() async {
    if (bothControllersNull) {
      return;
    }

    try {
      _isSingleLineView
          ? await _cardInputController?.requestFocus()
          : await _formInputController?.requestFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  Future<void> clearFocus() async {
    if (bothControllersNull) {
      return;
    }

    try {
      _isSingleLineView
          ? await _cardInputController?.clearFocus()
          : await _formInputController?.clearFocus();
    } on PlatformException catch (e) {
      updateStatus(e.message!);
    }
  }

  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const SettingsModalBottomsheet(
        title: "Credit Card View Settings",
        child: CardDetailsSettings(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settingsModel = Provider.of<CardDetailsSettingsModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    _isSingleLineView = _settingsModel!.showSingleLineCardDetailsView;
    return PageWidget(
      title: "Credit Card",
      onSettingsPressed: _showFullScreenModal,
      sdkInitialized: widget.sdkInitialized,
      digitalWalletReady: widget.digitalWalletReady,
      bodyContent: Column(
        children: <Widget>[
          if (widget
              .sdkInitialized) // The SDK must be initialized prior to displaying the text field
            _isSingleLineView
                ? CardDetailsSingleLineTextField(
                    onControllerCreated: onSingleLineControllerCreated,
                    onInputChanged: onInputChanged,
                    onValidStateChanged: onValidStateChanged,
                    onFocusChanged: onFocusChanged,
                    onErrorMessageChanged: onErrorMessagedChanged,
                    enabled: _settingsModel?.enabled ?? true,
                    displayErrorMessages:
                        _settingsModel?.showErrorMessages ?? true,
                  )
                : CardDetailsFormTextField(
                    onControllerCreated: onFormControllerCreated,
                    onValidStateChanged: onFormValidStateChanged,
                    enabled: _settingsModel?.enabled ?? true,
                  ),
          PaymentButtonsWidget(
            createPaymentMethod: createPaymentMethod,
            clear: clear,
            showSingleLineCardDetailsView: _isSingleLineView,
            buttonData: [
              {"label": "Card Type", "onPressed": getCardType},
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
