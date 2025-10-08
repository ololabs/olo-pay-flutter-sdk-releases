// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field_state.dart';

/// @nodoc
@protected
extension OloMethodChannel on MethodChannel {
  /// @nodoc
  Future<Map<K, V>?> invokeOloMapMethod<K, V>(
    String method, [
    dynamic arguments,
  ]) async {
    try {
      return await invokeMapMethod(method, arguments);
    } on MissingPluginException catch (e) {
      throw PlatformExceptionFactory.createFromError(error: e);
    }
  }

  /// @nodoc
  Future<T?> invokeOloMethod<T>(String method, [dynamic arguments]) async {
    try {
      return await invokeMethod(method, arguments);
    } on MissingPluginException catch (e) {
      throw PlatformExceptionFactory.createFromError(error: e);
    }
  }
}

/// @nodoc
@protected
extension CardFieldStateMap on Map<dynamic, dynamic> {
  Map<CardField, CardFieldState> toFieldStateMap() {
    return map(
      (key, value) => MapEntry<CardField, CardFieldState>(
        CardField.fromStringValue(key)!,
        CardFieldState.fromMap(value)!,
      ),
    );
  }
}
