// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Defines custom error messages for different field error types
class CustomFieldErrors {
  /// Custom error messge for when the field is empty
  ///
  /// Providing any string, including an empty string, will overwrite the default error.
  /// If this value is `null`, the default error will be used.
  final String? emptyError;

  /// Custom error message for when the field is invalid
  ///
  /// Providing any string, including an empty string, will overwrite the default error.
  /// If this value is `null`, the default error will be used.
  final String? invalidError;

  /// Create custom error messages by providing values for each error type
  const CustomFieldErrors({
    required this.emptyError,
    required this.invalidError,
  });

  /// Create custom error messages by providing values for only the desired error type(s)
  const CustomFieldErrors.only({this.emptyError, this.invalidError});

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.emptyError: emptyError,
      DataKeys.invalidError: invalidError,
    };
  }
}
