// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/models/cvv_settings_model.dart';
import 'package:olo_pay_sdk_example/widgets/settings/settings_section.dart';
import 'package:provider/provider.dart';

class CvvEventSettings extends StatelessWidget {
  const CvvEventSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<CvvSettingsModel>(context);
    return SettingsSection(
      title: "Event Settigns",
      children: [
        SwitchListTile(
          title: const Text("onErrorMessageChanged Event"),
          value: settingsModel.onErrorMessageChangedEnabled,
          onChanged: (bool value) =>
              settingsModel.toggleOnErrorMessageChangedEnabled(),
        ),
        SwitchListTile(
          title: const Text("onInputChanged Event"),
          value: settingsModel.onInputChangedEnabled,
          onChanged: (bool value) =>
              settingsModel.toggleOnInputChangedEnabled(),
        ),
        SwitchListTile(
          title: const Text("onValidStateChanged Event"),
          value: settingsModel.onValidStateChangedEnabled,
          onChanged: (bool value) =>
              settingsModel.toggleOnValidStateChangedEnabled(),
        ),
        SwitchListTile(
          title: const Text("onFocusChanged Event"),
          value: settingsModel.onFocusChangedEnabled,
          onChanged: (bool value) =>
              settingsModel.toggleOnFocusChangedEnabled(),
        ),
      ],
    );
  }
}
