// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/olo_pay_setup_parameters.dart';

void main() {
  group('OloPaySetupParameters:', () {
    test('Optional constructor params have correct default value', () {
      const params = OloPaySetupParameters();
      expect(params.productionEnvironment, true);
    });
  });
}
