// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
// Adapted from here: https://stackoverflow.com/questions/55147586/flutter-convert-color-to-hex-string
import 'package:flutter/material.dart';

/// @nodoc
extension HexColor on Color {
  String toHex() => '#'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
