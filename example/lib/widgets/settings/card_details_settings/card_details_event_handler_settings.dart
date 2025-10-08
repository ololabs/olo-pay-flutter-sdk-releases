// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/models/single_line_view_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/settings/settings_section.dart';
import 'package:provider/provider.dart';

class CardDetailsEventHandlersSettings extends StatelessWidget {
  const CardDetailsEventHandlersSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<CardDetailsSettingsModel>(context);
    return SettingsSection(
      title: "Event Settings",
      children: [
        SwitchListTile(
          title: const Text("onValidStateChanged Event"),
          value: settingsModel.onValidStateChangedEnabled,
          onChanged: (bool value) =>
              settingsModel.toggleOnValidStateChangedEnabled(),
        ),
        if (settingsModel.showSingleLineCardDetailsView) ...[
          SwitchListTile(
            title: const Text("onInputChanged Event"),
            value: settingsModel.onInputChangedEnabled,
            onChanged: (bool value) =>
                settingsModel.toggleOnInputChangedEnabled(),
          ),
          SwitchListTile(
            title: const Text("onFocusChanged Event"),
            value: settingsModel.onFocusChangedEnabled,
            onChanged: (bool value) =>
                settingsModel.toggleOnFocusChangedEnabled(),
          ),
          SwitchListTile(
            title: const Text("onErrorMessageChanged Event"),
            value: settingsModel.onErrorMessageChangedEnabled,
            onChanged: (bool value) =>
                settingsModel.toggleOnErrorMessageChangedEnabled(),
          ),
        ],
      ],
    );
  }
}
