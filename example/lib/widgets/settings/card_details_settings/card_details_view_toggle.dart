// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/models/single_line_view_settings_model.dart';
import 'package:provider/provider.dart';

class CardDetailsViewToggle extends StatelessWidget {
  const CardDetailsViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsModel = Provider.of<CardDetailsSettingsModel>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap:
                    settingsModel.showSingleLineCardDetailsView
                        ? () {
                          settingsModel.toggleShowSingleLineCardDetailsView();
                        }
                        : null,
                child: Text(
                  'Form View',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        settingsModel.showSingleLineCardDetailsView
                            ? FontWeight.normal
                            : FontWeight.bold,
                  ),
                ),
              ),
              Switch(
                value: settingsModel.showSingleLineCardDetailsView,
                onChanged: (bool value) {
                  settingsModel.toggleShowSingleLineCardDetailsView();
                },
              ),
              GestureDetector(
                onTap:
                    !settingsModel.showSingleLineCardDetailsView
                        ? () {
                          settingsModel.toggleShowSingleLineCardDetailsView();
                        }
                        : null,
                child: Text(
                  'Single Line View',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        !settingsModel.showSingleLineCardDetailsView
                            ? FontWeight.normal
                            : FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
