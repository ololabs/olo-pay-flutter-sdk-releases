// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/olo_pay_sdk_data_classes.dart';

void main() {
  group('TextFieldAlignment:', () {
    group('toString():', () {
      test('Converts value `center` to string', () {
        expect(TextFieldAlignment.center.toString(), "center");
      });
      test('Converts value `left` to string', () {
        expect(TextFieldAlignment.left.toString(), "left");
      });
      test('Converts value `right` to string', () {
        expect(TextFieldAlignment.right.toString(), "right");
      });
    });
  });
}
