// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';

void main() {
  final allParamsMap = const PaddingStyles(
    startPadding: 1.0,
    endPadding: 2.0,
    topPadding: 3.0,
    bottomPadding: 4.0,
  ).toMap();

  final defaultParamsMap = PaddingStyles.defaults.toMap();

  group('PaddingStyles:', () {
    group('toMap():', () {
      group('All Params:', () {
        test('Has correct length', () {
          expect(allParamsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(allParamsMap.containsKey('startPadding'), true);
          expect(allParamsMap.containsKey('endPadding'), true);
          expect(allParamsMap.containsKey('topPadding'), true);
          expect(allParamsMap.containsKey('bottomPadding'), true);
        });

        test('Keys have correct values', () {
          expect(allParamsMap['startPadding'], 1.0);
          expect(allParamsMap['endPadding'], 2.0);
          expect(allParamsMap['topPadding'], 3.0);
          expect(allParamsMap['bottomPadding'], 4.0);
        });
      });

      group('Default Params:', () {
        test('Has correct length', () {
          expect(defaultParamsMap.length, 4);
        });

        test('Has correct keys', () {
          expect(defaultParamsMap.containsKey('startPadding'), true);
          expect(defaultParamsMap.containsKey('endPadding'), true);
          expect(defaultParamsMap.containsKey('topPadding'), true);
          expect(defaultParamsMap.containsKey('bottomPadding'), true);
        });

        test('Keys have correct values', () {
          expect(defaultParamsMap['startPadding'], 8.0);
          expect(defaultParamsMap['endPadding'], 8.0);
          expect(defaultParamsMap['topPadding'], 0.0);
          expect(defaultParamsMap['bottomPadding'], 0.0);
        });

        test("Same as empty only() constructor", () {
          final emptyOnlyConstructor = const PaddingStyles.only().toMap();

          expect(defaultParamsMap['startPadding'],
              emptyOnlyConstructor['startPadding']);
          expect(defaultParamsMap['endPadding'],
              emptyOnlyConstructor['endPadding']);
          expect(defaultParamsMap['topPadding'],
              emptyOnlyConstructor['topPadding']);
          expect(defaultParamsMap['bottomPadding'],
              emptyOnlyConstructor['bottomPadding']);
        });
      });
    });
  });
}
