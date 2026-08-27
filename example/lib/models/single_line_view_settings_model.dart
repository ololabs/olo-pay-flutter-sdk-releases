// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

class CardDetailsSettingsModel with ChangeNotifier {
  bool _showSingleLineCardDetailsView = true;

  bool _enabled = true;
  bool _showErrorMessages = true;

  bool _onInputChangedEnabled = false;
  bool _onFocusChangedEnabled = false;
  bool _onValidStateChangedEnabled = false;
  bool _onErrorMessageChangedEnabled = false;

  bool get showSingleLineCardDetailsView => _showSingleLineCardDetailsView;

  bool get enabled => _enabled;
  bool get showErrorMessages => _showErrorMessages;

  bool get onInputChangedEnabled => _onInputChangedEnabled;
  bool get onFocusChangedEnabled => _onFocusChangedEnabled;
  bool get onValidStateChangedEnabled => _onValidStateChangedEnabled;
  bool get onErrorMessageChangedEnabled => _onErrorMessageChangedEnabled;

  void toggleEnabled() {
    _enabled = !_enabled;
    notifyListeners();
  }

  void toggleShowErrorMessages() {
    _showErrorMessages = !_showErrorMessages;
    notifyListeners();
  }

  void toggleShowSingleLineCardDetailsView() {
    _showSingleLineCardDetailsView = !_showSingleLineCardDetailsView;
    notifyListeners();
  }

  void toggleOnErrorMessageChangedEnabled() {
    _onErrorMessageChangedEnabled = !_onErrorMessageChangedEnabled;
    notifyListeners();
  }

  void toggleOnInputChangedEnabled() {
    _onInputChangedEnabled = !_onInputChangedEnabled;
    notifyListeners();
  }

  void toggleOnFocusChangedEnabled() {
    _onFocusChangedEnabled = !_onFocusChangedEnabled;
    notifyListeners();
  }

  void toggleOnValidStateChangedEnabled() {
    _onValidStateChangedEnabled = !_onValidStateChangedEnabled;
    notifyListeners();
  }
}
