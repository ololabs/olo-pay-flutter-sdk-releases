// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.data

class ErrorCodes {
    companion object {
        // Method call rejection code keys
        const val InvalidParameter = "InvalidParameter"
        const val MissingParameter = "MissingParameter"
        const val UnexpectedParameterType = "UnexpectedParameterType"
        const val UninitializedSdk = "SdkUninitialized"
        const val DigitalWalletUninitialized = "DigitalWalletUninitialized"
        const val InvalidGooglePaySetup = "InvalidGooglePaySetup"
        const val DigitalWalletNotReady = "DigitalWalletNotReady"
        const val UnexpectedError = "UnexpectedError"

        // Do not rename this key... it maps to an OPError type, but we also
        // use if for some other scenarios in the RN SDK
        const val GeneralError = "generalError"

        // Error codes based on API exceptions
        const val ApiError = "ApiError"
        const val InvalidRequest = "InvalidRequest"
        const val Connection = "ConnectionError"
        const val RateLimit = "RateLimitError"
        const val Authentication = "AuthenticationError"

        // Error codes base on card exceptions
        const val InvalidCardDetails = "InvalidCardDetails"
        const val InvalidNumber = "InvalidNumber"
        const val InvalidExpiration = "InvalidExpiration"
        const val InvalidCvv = "InvalidCVV"
        const val InvalidPostalCode = "InvalidPostalCode"
        const val ExpiredCard = "ExpiredCard"
        const val CardDeclined = "CardDeclined"
        const val ProcessingError = "ProcessingError"
        const val UnknownCardError = "UnknownCardError"
    }
}
