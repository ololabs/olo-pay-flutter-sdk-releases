import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/internal_error_codes.dart';
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_codes.dart';

class PlatformExceptionFactory {
  static PlatformException create({
    required String errorDetails,
    String errorCode = ErrorCodes.unexpectedError,
    String userMessage = Strings.unexpectedError,
    StackTrace? trace,
    bool shouldAssert = true,
  }) {
    if (shouldAssert) {
      assert(false, errorDetails);
    }

    return PlatformException(
      code: errorCode,
      message: userMessage,
      details: errorDetails,
      stacktrace:
          trace != null ? trace.toString() : StackTrace.current.toString(),
    );
  }

  static PlatformException createFromError({
    required Object error,
    String defaultErrorCode = ErrorCodes.unexpectedError,
    String defaultUserMessage = Strings.unexpectedError,
    StackTrace? trace,
  }) {
    if (error is PlatformException) {
      return createFromException(exception: error);
    }

    if (error is MissingPluginException) {
      assert(false, error.message);
    }

    return PlatformException(
      code: defaultErrorCode,
      message: defaultUserMessage,
      details: error.toString(),
      stacktrace:
          trace != null ? trace.toString() : StackTrace.current.toString(),
    );
  }

  static PlatformException createFromException({
    required PlatformException exception,
    String defaultErrorCode = ErrorCodes.unexpectedError,
    String defaultUserMessage = Strings.unexpectedError,
  }) {
    assertException(exception);

    if (InternalErrorCodes.all.contains(exception.code)) {
      return PlatformException(
        code: defaultErrorCode,
        message: defaultUserMessage,
        details: exception.details,
        stacktrace: exception.stacktrace,
      );
    }

    // If the error doesn't use internal error codes,
    // just return the same instance that as passed in
    return exception;
  }

  static assertError(Object error) {
    if (error is PlatformException) {
      assertException(error);
    }
  }

  static assertException(PlatformException exception) {
    assert(!InternalErrorCodes.all.contains(exception.code), exception.details);
  }
}