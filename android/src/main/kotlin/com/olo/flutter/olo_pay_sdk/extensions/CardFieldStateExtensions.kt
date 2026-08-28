// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.CardField
import com.olo.olopay.data.ICardFieldState

fun ICardFieldState.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.IsValidKey to this.isValid,
        DataKeys.IsFocusedKey to this.isFocused,
        DataKeys.IsEmptyKey to this.isEmpty,
        DataKeys.WasEditedKey to this.wasEdited,
        DataKeys.WasFocusedKey to this.wasFocused
    )
}

fun Map<CardField, ICardFieldState>.toMap(): Map<String, Any> {
    return mapOf(
        CardField.CardNumber.toString() to this[CardField.CardNumber]!!.toMap(),
        CardField.Expiration.toString() to this[CardField.Expiration]!!.toMap(),
        CardField.Cvv.toString() to this[CardField.Cvv]!!.toMap(),
        CardField.PostalCode.toString() to this[CardField.PostalCode]!!.toMap()
    )
}