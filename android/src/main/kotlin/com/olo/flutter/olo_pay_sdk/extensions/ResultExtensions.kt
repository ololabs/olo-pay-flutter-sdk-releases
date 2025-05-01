// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.utils.OloPayLog
import com.olo.olopay.data.CardErrorType
import com.olo.olopay.exceptions.ApiConnectionException
import com.olo.olopay.exceptions.ApiException
import com.olo.olopay.exceptions.CardException
import com.olo.olopay.exceptions.InvalidRequestException
import com.olo.olopay.exceptions.OloPayException
import com.olo.olopay.exceptions.RateLimitException
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.oloError(e: OloPayException) {
    oloError(e, "Unexpected error occurred")
}

fun MethodChannel.Result.oloError(e: OloPayException, defaultMessage: String) {
    val errorCode = getErrorCode(e)
    val errorMessage = if (e.message.isNullOrEmpty()) defaultMessage else e.message!!
    OloPayLog.e("${errorCode}\n$errorMessage", e)
    error(errorCode, errorMessage, null)
}

fun MethodChannel.Result.oloError(errorCode: String, message: String) {
    OloPayLog.e("${errorCode}\n$message")
    error(errorCode, message, null)
}

private fun getErrorCode(e: OloPayException): String {
    val cardException = e as? CardException
    if (cardException != null) {
        return getErrorCode(cardException.type)
    }

    if (e is ApiException)
        return ErrorCodes.ApiError

    if (e is InvalidRequestException)
        return ErrorCodes.InvalidRequest

    if (e is ApiConnectionException)
        return ErrorCodes.Connection

    if (e is RateLimitException)
        return ErrorCodes.RateLimit

    return ErrorCodes.GeneralError
}

private fun getErrorCode(cardErrorType: CardErrorType): String {
    return when (cardErrorType) {
        CardErrorType.InvalidNumber -> ErrorCodes.InvalidNumber
        CardErrorType.InvalidExpMonth -> ErrorCodes.InvalidExpiration
        CardErrorType.InvalidExpYear -> ErrorCodes.InvalidExpiration
        CardErrorType.InvalidCVV -> ErrorCodes.InvalidCvv
        CardErrorType.InvalidZip -> ErrorCodes.InvalidPostalCode
        CardErrorType.ExpiredCard -> ErrorCodes.ExpiredCard
        CardErrorType.CardDeclined -> ErrorCodes.CardDeclined
        CardErrorType.ProcessingError -> ErrorCodes.ProcessingError
        CardErrorType.UnknownCardError -> ErrorCodes.UnknownCardError
    }
}