// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/google_pay_vendor_parameters.dart';

void main() {
  final paramsMap = const GooglePayVendorParameters(
    countryCode: "US",
    merchantName: "Test Merchant",
  ).toMap();

  group('GooglePayVendorParameters:', () {
    group('toMap():', () {
      test('Has correct length', () {
        expect(paramsMap.length, 2);
      });

      test('Has correct keys', () {
        expect(paramsMap.containsKey("countryCode"), true);
        expect(paramsMap.containsKey("merchantName"), true);
      });

      test('Keys have correct values', () {
        expect(paramsMap["countryCode"], "US");
        expect(paramsMap["merchantName"], "Test Merchant");
      });
    });
  });
}
