// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function(BuildContext context) onSettingsPressed;

  const AppBarWidget({
    Key? key,
    required this.title,
    required this.onSettingsPressed,
  }) : super(key: key);

  double get logoTopPadding =>
      defaultTargetPlatform == TargetPlatform.iOS ? 60 : 30;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;

    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color.fromRGBO(45, 150, 255, 1),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings Icon',
            onPressed: () {
              onSettingsPressed(context);
            },
          ),
        ),
      ],
      flexibleSpace: Padding(
        padding: EdgeInsets.only(left: 8.0, top: logoTopPadding),
        child: Align(
          alignment: Alignment.centerLeft,
          child:
              brightness == Brightness.light
                  ? Image.asset(
                    'assets/images/Olo_Pay_black.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                  )
                  : Image.asset(
                    'assets/images/Olo_Pay_white.png',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.contain,
                  ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
