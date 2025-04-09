// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

class DigitalWalletSettingsModel with ChangeNotifier {
  bool _usePayNowButton = true;
  bool _enabled = true;
  bool _useLineItems = false;

  bool get usePayNowButton => _usePayNowButton;
  bool get enabled => _enabled;
  bool get useLineItems => _useLineItems;

  void toggleUsePayNowButton() {
    _usePayNowButton = !_usePayNowButton;
    notifyListeners();
  }

  void toggleEnabled() {
    _enabled = !_enabled;
    notifyListeners();
  }

  void toggleUseLineItems() {
    _useLineItems = !_useLineItems;
    notifyListeners();
  }
}
