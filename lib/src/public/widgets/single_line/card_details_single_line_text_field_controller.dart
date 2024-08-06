// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field_state.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_type.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';
import 'package:olo_pay_sdk/src/public/data_classes/payment_method.dart';
import 'package:olo_pay_sdk/src/public/widgets/single_line/card_details_single_line_text_field.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';

/// A controller for [CardDetailsSingleLineTextField]
///
/// You can get an instance of this class using [CardDetailsSingleLineTextField.onControllerCreated].
class CardDetailsSingleLineTextFieldController extends ChangeNotifier {
  late MethodChannel _channel;
  late CardDetailsErrorMessageChanged? _errorHandler;

  /// @nodoc
  @protected
  CardDetailsSingleLineTextFieldController(
      MethodChannel channel, CardDetailsErrorMessageChanged? errorHandler) {
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
      final Map<dynamic, dynamic>? result =
          await _channel.invokeOloMapMethod(DataKeys.createPaymentMethodKey);

      // This should never happen
      if (result == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      return PaymentMethod(
          id: result[DataKeys.pmIdKey],
          last4: result[DataKeys.pmLast4Key],
          cardType: CardType.fromStringValue(result[DataKeys.pmCardTypeKey]),
          expirationMonth: result[DataKeys.pmExpirationMonthKey],
          expirationYear: result[DataKeys.pmExpirationYearKey],
          postalCode: result[DataKeys.pmPostalCodeKey],
          country: result[DataKeys.pmCountryCodeKey],
          isDigitalWallet: result[DataKeys.pmIsDigitalWalletKey],
          productionEnvironment: result[DataKeys.productionEnvironmentKey]);
    } on PlatformException catch (e) {
      _errorHandler?.call(e.message!);
      rethrow;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Returns the current state of the widget for each field
  ///
  /// **NOTE:** It may not be necessary to use this method, as this state data can also be accessed via the
  /// following callbacks:
  /// - [CardDetailsSingleLineTextField.onInputChanged]
  /// - [CardDetailsSingleLineTextField.onValidStateChanged]
  /// - [CardDetailsSingleLineTextField.onFocusChanged]
  ///
  /// This state can be useful when implementing custom behavior of the widget (e.g. providing custom error messages
  /// with custom logic determining when to show the errors).
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<Map<CardField, CardFieldState>> getState() async {
    try {
      final Map<dynamic, dynamic>? result =
          await _channel.invokeOloMapMethod(DataKeys.getStateMethodKey);

      // This should never happen
      if (result == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      return result.toFieldStateMap();
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Convenience method for to query whether user-entered card details are currently valid
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isValid() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isValidMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Convenience method to query the detected card type
  ///
  /// **NOTE:** Unless implementing custom business logic, there is generally no need to use this method
  /// because a [PaymentMethod] created using [createPaymentMethod] includes this data.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<CardType> getCardType() async {
    try {
      return CardType.fromStringValue(
          await _channel.invokeOloMethod(DataKeys.getCardTypeMethodKey));
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Enable or disable user-interaction with the widget
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> setEnabled(bool enabled) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.setEnabledMethodKey,
          {DataKeys.enabledParameterKey: enabled});
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Clear all user-entered data in the widget's fields and reset the widget to its initial state
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> clearFields() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.clearFieldsMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Check if the widget is currently enabled (i.e. able to response to user input)
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isEnabled() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isEnabledMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Check if there are error messages that can be displayed to the user
  ///
  /// **NOTE:** Unless implementing custom business logic there is generally no need to use this method. Error messages
  /// can be obtained using the [CardDetailsSingleLineTextField.onErrorMessageChanged] callback.
  ///
  /// If [ignoreUneditedFields] is `true` (the default) only fields that have been "edited" by the user will be
  /// considered. If `false` then all fields regardless will be considered regardless of their current state.
  ///
  /// For purposes of this method, "edited" means the user has entered text and focus has changed to another field while
  /// not empty. Once a field is considered "edited", it stays edited even if empty, unless [clearFields] is called to reset
  /// the state.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> hasErrorMessage({bool ignoreUneditedFields = true}) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.hasErrorMessageMethodKey, {
        DataKeys.ignoreUneditedFieldsParameterKey: ignoreUneditedFields,
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Get an error message that can be displayed to the user
  ///
  /// **Note:** Unless implementing custom business logic there is generally no need to use this method. Error messages
  /// can be obtained using the [CardDetailsSingleLineTextField.onErrorMessageChanged] callback.
  ///
  /// If [ignoreUneditedFields] is `true` (the default) only fields that have been "edited" by the user will be
  /// considered. If `false` then all fields will be considered regardless of their current state.
  ///
  /// For purposes of this method, "edited" means the user has entered text and focus has changed to another field while
  /// not empty. Once a field is considered "edited", it stays edited even if empty, unless [clearFields] is called to reset
  /// the state.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<String> getErrorMessage({bool ignoreUneditedFields = true}) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.getErrorMessageMethodKey, {
        DataKeys.ignoreUneditedFieldsParameterKey: ignoreUneditedFields,
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Puts focus on the widget and displays the keyboard
  ///
  /// **Note:** Due to differences across platforms, on Android the card number field will always be given focus. On iOS,
  /// the last field that had focus will regain that focus.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> requestFocus() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.requestFocusMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  /// Clears focus from the card number field and dismisses the keyboard
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> clearFocus() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.clearFocusMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }
}
