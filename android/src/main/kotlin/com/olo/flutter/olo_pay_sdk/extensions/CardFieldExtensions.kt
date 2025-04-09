// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.CardField

fun CardField.Companion.from(value: String):CardField {
    return when(value) {
        DataKeys.ExpirationFieldValueKey -> CardField.Expiration
        DataKeys.CvvFieldValueKey -> CardField.Cvv
        DataKeys.PostalCodeFieldValueKey -> CardField.PostalCode
        else -> CardField.CardNumber
    }
}
