// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/models/digital_wallet_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/settings/settings_section.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

class DigitalWalletBooleanSettings extends StatelessWidget {
  const DigitalWalletBooleanSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<DigitalWalletSettingsModel>(context);
    return SettingsSection(
      title: "Boolean Settings",
      children: [
        if (defaultTargetPlatform == TargetPlatform.android)
          SwitchListTile(
            title: const Text("Use Pay Now Button"),
            value: settingsModel.usePayNowButton,
            onChanged: (bool value) => settingsModel.toggleUsePayNowButton(),
          ),
        SwitchListTile(
          title: const Text("Enabled"),
          value: settingsModel.enabled,
          onChanged: (bool value) => settingsModel.toggleEnabled(),
        ),
        SwitchListTile(
          title: const Text("Use Line Items"),
          value: settingsModel.useLineItems,
          onChanged: (bool value) => settingsModel.toggleUseLineItems(),
        ),
      ],
    );
  }
}
