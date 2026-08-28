// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/widgets/settings/card_details_settings/card_details_boolean_settings.dart';
import 'package:olo_pay_sdk_example/widgets/settings/card_details_settings/card_details_event_handler_settings.dart';
import 'package:olo_pay_sdk_example/widgets/settings/card_details_settings/card_details_view_toggle.dart';

class CardDetailsSettings extends StatelessWidget {
  const CardDetailsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CardDetailsViewToggle(),
        CardDetailsBooleanSettings(),
        CardDetailsEventHandlersSettings(),
      ],
    );
  }
}
