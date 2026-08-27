// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';

class CardDetailsFormTextFieldController extends ChangeNotifier {
  late MethodChannel _channel;
  late CardDetailsErrorMessageChanged? _errorHandler;

  /// @nodoc
  @protected
  CardDetailsFormTextFieldController(
    MethodChannel channel,
    CardDetailsErrorMessageChanged? errorHandler,
  ) {
    _channel = channel;
    _errorHandler = errorHandler;
  }

  /// Attempt to create a payment method based on the card details entered by the user
  ///
  /// Returns a [PaymentMethod] if the card details are valid.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The `code` property on the exception can be used to determine
  /// what went wrong and take appropriate action. The `message` property can be used to get more information about what
  /// went wrong
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// **Common Codes:** _(the error message associated with these codes are user-friendly)_
  /// - [ErrorCodes.invalidNumber]
  /// - [ErrorCodes.invalidExpiration]
  /// - [ErrorCodes.invalidCvv]
  /// - [ErrorCodes.invalidPostalCode]
  /// **Uncommon Codes:** _(these do no occur very often)_
  /// - [ErrorCodes.invalidCardDetails]
  /// - [ErrorCodes.apiError]
  /// - [ErrorCodes.invalidRequest]
  /// - [ErrorCodes.connection]
  /// - [ErrorCodes.rateLimit]
  /// - [ErrorCodes.authentication]
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.expiredCard]
  /// - [ErrorCodes.cardDeclined]
  /// - [ErrorCodes.processingError]
  /// - [ErrorCodes.unknownCard]
  /// - [ErrorCodes.generalError]
  Future<PaymentMethod> createPaymentMethod() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeOloMapMethod(
        DataKeys.createPaymentMethodKey,
      );

      if (result == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      return PaymentMethod.fromMap(result);
    } on PlatformException catch (e) {
      _errorHandler?.call(e.message!);
      rethrow;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Convenience method for to query whether user-entered card details are currently valid
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isValid() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isValidMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Convenience method to query the detected card type (Android only)
  ///
  /// **NOTE:** Unless implementing custom business logic, there is generally no need to use this method
  /// because a [PaymentMethod] created using [createPaymentMethod] includes this data.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<CardType> getCardType() async {
    try {
      return CardType.fromStringValue(
        await _channel.invokeOloMethod(DataKeys.getCardTypeMethodKey),
      );
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Clear all user-entered data in the widget's fields and reset the widget to its initial state (Android only)
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> clearFields() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.clearFieldsMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Check if the widget is currently enabled (i.e. able to respond to user-input)
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isEnabled() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isEnabledMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Puts focus on the widget and displays the keyboard
  ///
  /// **Note:** Focus will be placed on the field passed as the `focusField` parameter
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> requestFocus({
    CardField focusField = CardField.cardNumber,
  }) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.requestFocusMethodKey, {
        DataKeys.focusFieldParameterKey: focusField.stringValue,
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Clears focus from the card number field and dismisses the keyboard
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> clearFocus() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.clearFocusMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }
}
