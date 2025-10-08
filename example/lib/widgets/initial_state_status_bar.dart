// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';

class InitialStateStatusBar extends StatelessWidget {
  final bool sdkInitialized;
  final bool digitalWalletReady;
  const InitialStateStatusBar({
    Key? key,
    required this.digitalWalletReady,
    required this.sdkInitialized,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "SDK Initialized: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          sdkInitialized
              ? const Icon(Icons.check_circle_outline, color: Colors.green)
              : const Icon(Icons.cancel_outlined, color: Colors.red),
          const VerticalDivider(thickness: 1),
          const Text(
            "Digital Wallets Ready: ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          digitalWalletReady
              ? const Icon(Icons.check_circle_outline, color: Colors.green)
              : const Icon(Icons.cancel_outlined, color: Colors.red),
        ],
      ),
    );
  }
}
