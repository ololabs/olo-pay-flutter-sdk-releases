// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/private/extensions/color_extensions.dart';

void main() {
  group('ColorExtensions:', () {
    group('toHex():', () {
      test('Flutter named color converts to hex', () {
        expect(Colors.red.toHex(), '#fff44336');
      });

      test('Color with alpha converts to hex', () {
        expect(const Color.fromRGBO(54, 244, 140, 0.50).toHex(), '#8036f48c');
      });
    });
  });
}
