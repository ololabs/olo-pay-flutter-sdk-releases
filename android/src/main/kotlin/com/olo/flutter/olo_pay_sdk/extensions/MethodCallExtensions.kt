package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.EmptyValueException
import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.data.MissingKeyException
import com.olo.flutter.olo_pay_sdk.data.NullValueException
import com.olo.flutter.olo_pay_sdk.data.UnexpectedTypeException
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

inline fun <reified T> MethodCall.getArgOrErrorResult(
    key: String,
    baseError: String,
    result: MethodChannel.Result
): T {
    return getArgOrErrorResult(key, baseError, result, T::class.java)
}

fun <T> MethodCall.getArgOrErrorResult(
    key: String,
    baseError: String,
    result: MethodChannel.Result,
    tClass: Class<T>
): T {
    try {
        return getArgOrThrow(key, tClass)
    } catch (e: MissingKeyException) {
        val errorMessage = "$baseError: Missing parameter '$key'"
        result.oloError(ErrorCodes.MissingParameter, errorMessage)
        throw MissingKeyException(errorMessage, e)
    } catch (e: NullValueException) {
        val errorMessage = "$baseError: Missing parameter '$key'"
        result.oloError(ErrorCodes.MissingParameter, errorMessage)
        throw NullValueException(errorMessage, e)
    } catch (e: UnexpectedTypeException) {
        val errorMessage = "$baseError: Value for '$key' is not of type ${tClass.simpleName}"
        result.oloError(ErrorCodes.UnexpectedParameterType, errorMessage)
        throw UnexpectedTypeException(errorMessage, e)
    }
}

inline fun <reified T> MethodCall.getArgOrErrorResult(
    key: String,
    default: T,
    baseError: String,
    result: MethodChannel.Result
): T {
    return getArgOrErrorResult(key, default, baseError, result, T::class.java)
}

fun <T> MethodCall.getArgOrErrorResult(
    key: String,
    default: T,
    baseError: String,
    result: MethodChannel.Result,
    tClass: Class<T>
): T {
    try {
        return getArgOrThrow(key, default, tClass)
    } catch (e: UnexpectedTypeException) {
        val errorMessage = "$baseError: Value for '$key' is not of type ${tClass.simpleName}"
        result.oloError(ErrorCodes.UnexpectedParameterType, errorMessage)
        throw UnexpectedTypeException(errorMessage, e)
    }
}

fun MethodCall.getStringArgOrErrorResult(
    key: String,
    default: String,
    baseError: String,
    acceptEmptyValue: Boolean,
    result: MethodChannel.Result
): String {
    try {
        var value = getArgOrThrow(key, default, String::class.java).trim()

        if (!acceptEmptyValue && value.isEmpty()) {
            value = default
        }

        return value
    } catch (e: UnexpectedTypeException) {
        val errorMessage = "$baseError: Value for '$key' is not of type ${String::class.java.simpleName}"
        result.oloError(ErrorCodes.UnexpectedParameterType, errorMessage)
        throw UnexpectedTypeException(errorMessage, e)
    }
}

fun MethodCall.getStringArgOrErrorResult(
    key: String,
    baseError: String,
    acceptEmptyValue: Boolean,
    result: MethodChannel.Result
): String {
    val value = getArgOrErrorResult(key, baseError, result, String::class.java).trim()

    if (!acceptEmptyValue && value.isEmpty()) {
        val errorMessage = "$baseError: Value for '$key' cannot be empty"
        result.oloError(ErrorCodes.InvalidParameter, errorMessage)
        throw EmptyValueException(errorMessage)
    }

    return value
}

inline fun <reified T> MethodCall.getArgOrThrow(key: String): T {
    return getArgOrThrow(key, T::class.java)
}

fun <T> MethodCall.getArgOrThrow(
    key: String,
    tClass: Class<T>
): T {
    if (!this.hasArgument(key)) {
        throw MissingKeyException("Missing key '$key'")
    }

    this.argument<T>(key)?.let {
        if (it::class.java != tClass) {
            throw UnexpectedTypeException("Value for '$key' is not of type ${tClass.simpleName}")
        }

        return it
    }

    throw NullValueException("Value for '$key' is null")
}

inline fun<reified T> MethodCall.getArgOrThrow(key: String, defaultValue: T): T {
    return getArgOrThrow(key, defaultValue, T::class.java)
}

fun <T> MethodCall.getArgOrThrow(
    key: String,
    defaultValue: T,
    tClass: Class<T>
): T {
    return try {
        getArgOrThrow(key, tClass)
    } catch (e: MissingKeyException) {
        defaultValue
    } catch (e: NullValueException) {
        defaultValue
    }
}