// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/widgets/settings/digital_wallet_settings/digital_wallet_boolean_settings.dart';

class DigitalWalletSettings extends StatelessWidget {
  const DigitalWalletSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(children: const [DigitalWalletBooleanSettings()]);
  }
}
