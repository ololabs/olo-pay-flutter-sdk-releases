// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.exceptions.GooglePayException

fun GooglePayException.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.DigitalWalletErrorMessageParameterKey to (this.message ?: ""),
        DataKeys.GPayErrorTypeParameterKey to this.errorType.toString(),
        DataKeys.DigitalWalletTypeParameterKey to DataKeys.DigitalWalletTypeParameterValue
    )
}