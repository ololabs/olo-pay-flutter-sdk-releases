// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk_example/widgets/app_bar.dart';
import 'package:olo_pay_sdk_example/widgets/initial_state_status_bar.dart';

class PageWidget extends StatelessWidget {
  final String title;
  final void Function(BuildContext context) onSettingsPressed;
  final Widget bodyContent;
  final Widget? expandedContent;
  final bool sdkInitialized;
  final bool digitalWalletReady;

  const PageWidget({
    Key? key,
    required this.title,
    required this.onSettingsPressed,
    required this.bodyContent,
    this.expandedContent,
    required this.sdkInitialized,
    required this.digitalWalletReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: title, onSettingsPressed: onSettingsPressed),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InitialStateStatusBar(
            digitalWalletReady: digitalWalletReady,
            sdkInitialized: sdkInitialized,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
            child: bodyContent,
          ),
          if (expandedContent != null) Expanded(child: expandedContent!),
        ],
      ),
    );
  }
}
