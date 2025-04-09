// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/olo_pay_sdk_data_classes.dart';
import 'package:olo_pay_sdk/olo_pay_sdk_data_types.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';

/// A controller for [CvvTextField]
///
/// You can get an instance of this class using [CvvTextField.onControllerCreated].
class CvvTextFieldController extends ChangeNotifier {
  late MethodChannel _channel;
  late CvvErrorMessageChanged? _errorHandler;

  /// @nodoc
  @protected
  CvvTextFieldController(
    MethodChannel channel,
    CvvErrorMessageChanged? errorHandler,
  ) {
    _channel = channel;
    _errorHandler = errorHandler;
  }

  /// Attempt to create a CVV update token based on the CVV details entered by the user
  ///
  /// Returns a [CvvUpdateToken] if the CVV value is in a valid format.
  ///
  /// If an error occurs a [PlatformException] will be thrown. The `code` property on the exception can be used to determine
  /// what went wrong and take appropriate action. The `message` property can be used to get more information about what
  /// went wrong
  ///
  /// When a [PlatformException] is thrown, the `code` property will be one of the following:
  /// - [ErrorCodes.invalidCvv]
  /// - [ErrorCodes.apiError]
  /// - [ErrorCodes.invalidRequest]
  /// - [ErrorCodes.connection]
  /// - [ErrorCodes.rateLimit]
  /// - [ErrorCodes.authentication]
  /// - [ErrorCodes.unexpectedError]
  /// - [ErrorCodes.unknownCard]
  /// - [ErrorCodes.generalError]
  Future<CvvUpdateToken> createCvvUpdateToken() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeOloMapMethod(
        DataKeys.createCvvUpdateToken,
      );

      if (result == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      return CvvUpdateToken(
        id: result[DataKeys.cvvIdKey],
        productionEnvironment: result[DataKeys.productionEnvironmentKey],
      );
    } on PlatformException catch (e) {
      _errorHandler?.call(e.message!);
      rethrow;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Returns the current state of the widget
  ///
  /// **NOTE:** It may not be necessary to use this method, as this state data can also be accessed via the
  /// following callbacks:
  /// - [CvvTextField.onInputChanged]
  /// - [CvvTextField.onValidStateChanged]
  /// - [CvvTextField.onFocusChanged]
  ///
  /// This state can be useful when implementing custom behavior of the widget (e.g. providing custom error messages
  /// with custom logic determining when to show the errors).
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<CardFieldState> getState() async {
    try {
      final Map<dynamic, dynamic>? result = await _channel.invokeOloMapMethod(
        DataKeys.getStateMethodKey,
      );

      // This should never happen
      if (result == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      CardFieldState? state = CardFieldState.fromMap(result);

      if (state == null) {
        throw PlatformExceptionFactory.create(
          errorDetails: Strings.unexpectedNullValue,
        );
      }

      return state;
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Convenience method for to query whether the user-entered CVV value is in a valid format
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isValid() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isValidMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Clear user-entered data in the widget's field and reset the widget to its initial state
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> clear() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.clearFieldsMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Check if the widget is currently enabled (i.e. able to response to user input)
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> isEnabled() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.isEnabledMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Check if there are error messages that can be displayed to the user
  ///
  /// **NOTE:** Unless implementing custom business logic there is generally no need to use this method. Error messages
  /// can be obtained using the [CvvTextField.onErrorMessageChanged] callback.
  ///
  /// If [ignoreUneditedField] is `true` (the default) the field will only be considered if it has been "edited" by
  /// the user. If `false` then the this will check the field for possible errors regardless of the current state.
  ///
  /// For purposes of this method, "edited" means the user has entered text and focus has changed to another widget while
  /// not empty. Once the field is considered "edited", it stays edited even if empty, unless [clear] is called to reset
  /// the state.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<bool> hasErrorMessage({bool ignoreUneditedField = true}) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.hasErrorMessageMethodKey, {
        DataKeys.ignoreUneditedFieldsParameterKey: ignoreUneditedField,
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Get an error message that can be displayed to the user
  ///
  /// **Note:** Unless implementing custom business logic there is generally no need to use this method. Error messages
  /// can be obtained using the [CvvTextField.onErrorMessageChanged] callback.
  ///
  /// If [ignoreUneditedField] is `true` (the default) the field will only be considered if it has been "edited" by
  /// the user. If `false` then the this will check the field for possible errors regardless of the current state.
  ///
  /// For purposes of this method, "edited" means the user has entered text and focus has changed to another widget while
  /// not empty. Once a field is considered "edited", it stays edited even if empty, unless [clear] is called to reset
  /// the state.
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<String> getErrorMessage({bool ignoreUneditedField = true}) async {
    try {
      return await _channel.invokeOloMethod(DataKeys.getErrorMessageMethodKey, {
        DataKeys.ignoreUneditedFieldsParameterKey: ignoreUneditedField,
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Puts focus on the widget and displays the keyboard
  ///
  /// If a [PlatformException] is thrown, the `code` property would be [ErrorCodes.unexpectedError]
  Future<void> requestFocus() async {
    try {
      return await _channel.invokeOloMethod(DataKeys.requestFocusMethodKey);
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  /// Clears focus from the widget and dismisses the keyboard
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
