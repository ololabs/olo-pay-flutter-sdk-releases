// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

import 'package:olo_pay_sdk_example/app.dart';
import 'package:olo_pay_sdk_example/models/single_line_view_settings_model.dart';
import 'package:olo_pay_sdk_example/models/digital_wallet_settings_model.dart';
import 'package:olo_pay_sdk_example/models/cvv_settings_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CardDetailsSettingsModel>(
          create: (_) => CardDetailsSettingsModel(),
        ),
        ChangeNotifierProvider<DigitalWalletSettingsModel>(
          create: (_) => DigitalWalletSettingsModel(),
        ),
        ChangeNotifierProvider<CvvSettingsModel>(
          create: (_) => CvvSettingsModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
