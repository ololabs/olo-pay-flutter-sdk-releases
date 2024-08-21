import 'package:flutter_test/flutter_test.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field_state.dart';

const validDataMap = {
  "isValid": true,
  "isFocused": false,
  "isEmpty": true,
  "wasEdited": false,
  "wasFocused": true,
};

const mapWithMissingEntry = {
  "isValid": true,
  "isFocused": true,
  "isEmpty": true,
  "wasEdited": true,
  // "wasFocused": true, Removed for testing purposes
};

const mapWithNullValue = {
  "isValid": true,
  "isFocused": true,
  "isEmpty": true,
  "wasEdited": true,
  "wasFocused": null, // <--
};

const mapWithNonBooleanValueType = {
  "isValid": true,
  "isFocused": true,
  "isEmpty": true,
  "wasEdited": true,
  "wasFocused": "true", // <--
};

void main() {
  group('CardFieldState:', () {
    group('fromMap():', () {
      test('Converts map with all valid entries to CardFieldState', () {
        identical(
          CardFieldState.fromMap(validDataMap),
          const CardFieldState(
            isValid: false,
            isFocused: true,
            isEmpty: false,
            wasEdited: true,
            wasFocused: false,
          ),
        );
      });

      test('Map with missing required entry returns null', () {
        expect(CardFieldState.fromMap(mapWithMissingEntry), null);
      });

      test('Map with required value as null returns null', () {
        expect(CardFieldState.fromMap(mapWithNullValue), null);
      });

      test('Map with required value as wrong type returns null', () {
        expect(CardFieldState.fromMap(mapWithNonBooleanValueType), null);
      });
    });
  });
}
