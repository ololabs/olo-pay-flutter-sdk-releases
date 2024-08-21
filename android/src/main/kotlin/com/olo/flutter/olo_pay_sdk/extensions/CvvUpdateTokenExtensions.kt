// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.ICvvUpdateToken
import com.olo.olopay.data.OloPayEnvironment

fun ICvvUpdateToken.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.IDKey to (this.id ?: ""),
        DataKeys.ProductionEnvironmentKey to (this.environment == OloPayEnvironment.Production)
    )
}