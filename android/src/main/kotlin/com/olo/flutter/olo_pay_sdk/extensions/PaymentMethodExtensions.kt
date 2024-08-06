// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.IPaymentMethod
import com.olo.olopay.data.OloPayEnvironment

private const val InvalidExpiration = -1

fun IPaymentMethod.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.IDKey to (this.id ?: ""),
        DataKeys.Last4Key to (this.last4 ?: ""),
        DataKeys.CardTypeKey to (this.cardType?.description ?: ""),
        DataKeys.ExpirationMonthKey to (this.expirationMonth ?: InvalidExpiration),
        DataKeys.ExpirationYearKey to (this.expirationYear ?: InvalidExpiration),
        DataKeys.PostalCodeKey to (this.postalCode ?: ""),
        DataKeys.CountryCodeKey to (this.country ?: ""),
        DataKeys.IsDigitalWalletKey to this.isGooglePay,
        DataKeys.ProductionEnvironmentKey to (this.environment == OloPayEnvironment.Production)
    )
}