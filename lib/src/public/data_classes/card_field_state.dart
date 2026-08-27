// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';

/// Class representing the state of a [CardField]
class CardFieldState {
  /// The field is in a valid state
  final bool isValid;

  /// The field is currently focused
  final bool isFocused;

  /// The field is currently empty
  final bool isEmpty;

  /// The field was previously edited
  final bool wasEdited;

  /// The field was previously focused
  final bool wasFocused;

  /// @nodoc
  const CardFieldState({
    required this.isValid,
    required this.isFocused,
    required this.isEmpty,
    required this.wasEdited,
    required this.wasFocused,
  });

  /// @nodoc
  static CardFieldState? fromMap(Map<dynamic, dynamic> map) {
    try {
      return CardFieldState(
        isValid: map[DataKeys.isValidKey],
        isFocused: map[DataKeys.isFocusedKey],
        isEmpty: map[DataKeys.isEmptyKey],
        wasEdited: map[DataKeys.wasEditedKey],
        wasFocused: map[DataKeys.wasFocusedKey],
      );
    } catch (e) {
      return null;
    }
  }

  /// @nodoc
  @override
  String toString() {
    return '''
      isValid: $isValid
      isFocused: $isFocused
      isEmpty: $isEmpty
      wasEdited: $wasEdited
      wasFocused: $wasFocused
    ''';
  }
}
