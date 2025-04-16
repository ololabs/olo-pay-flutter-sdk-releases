// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/widgets/settings/cvv_settings/cvv_boolean_settings.dart';
import 'package:olo_pay_sdk_example/widgets/settings/cvv_settings/cvv_event_settings.dart';

class CvvSettings extends StatelessWidget {
  const CvvSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: const [CvvBooleanSettings(), CvvEventSettings()]);
  }
}
