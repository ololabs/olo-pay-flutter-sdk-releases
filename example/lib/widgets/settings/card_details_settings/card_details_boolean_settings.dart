// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/models/single_line_view_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/settings/settings_section.dart';
import 'package:provider/provider.dart';

class CardDetailsBooleanSettings extends StatelessWidget {
  const CardDetailsBooleanSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<CardDetailsSettingsModel>(context);
    return SettingsSection(
      title: "Boolean Settings",
      children: [
        SwitchListTile(
          title: const Text("Enabled"),
          value: settingsModel.enabled,
          onChanged: (bool value) => {settingsModel.toggleEnabled()},
        ),
        if (settingsModel.showSingleLineCardDetailsView)
          SwitchListTile(
            title: const Text("Show Error Messages"),
            value: settingsModel.showErrorMessages,
            onChanged: (bool value) => settingsModel.toggleShowErrorMessages(),
          ),
      ],
    );
  }
}
