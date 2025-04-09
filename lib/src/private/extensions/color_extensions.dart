// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
// Adapted from here: https://stackoverflow.com/questions/55147586/flutter-convert-color-to-hex-string
import 'package:flutter/material.dart';

extension HexColor on Color {
  String toHex() =>
      '#'
      '${(a * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(b * 255).round().toRadixString(16).padLeft(2, '0')}';
}
