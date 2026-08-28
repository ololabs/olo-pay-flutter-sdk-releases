// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

class CvvSettingsModel with ChangeNotifier {
  bool _enabled = true;
  bool _showErrorMessages = true;

  bool _onErrorMessageChangedEnabled = false;
  bool _onInputChangedEnabled = false;
  bool _onValidStateChangedEnabled = false;
  bool _onFocusChangedEnabled = false;

  bool get enabled => _enabled;
  bool get showErrorMessages => _showErrorMessages;

  bool get onErrorMessageChangedEnabled => _onErrorMessageChangedEnabled;
  bool get onInputChangedEnabled => _onInputChangedEnabled;
  bool get onValidStateChangedEnabled => _onValidStateChangedEnabled;
  bool get onFocusChangedEnabled => _onFocusChangedEnabled;

  void toggleEnabled() {
    _enabled = !_enabled;
    notifyListeners();
  }

  void toggleShowErrorMessages() {
    _showErrorMessages = !_showErrorMessages;
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

  void toggleOnValidStateChangedEnabled() {
    _onValidStateChangedEnabled = !_onValidStateChangedEnabled;
    notifyListeners();
  }

  void toggleOnFocusChangedEnabled() {
    _onFocusChangedEnabled = !_onFocusChangedEnabled;
    notifyListeners();
  }
}
