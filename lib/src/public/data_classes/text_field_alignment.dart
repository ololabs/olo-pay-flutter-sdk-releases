// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

enum TextFieldAlignment {
  left(stringValue: DataKeys.left),
  right(stringValue: DataKeys.right),
  center(stringValue: DataKeys.center);

  const TextFieldAlignment({required this.stringValue});

  final String stringValue;

  @override
  String toString() {
    return stringValue;
  }
}
