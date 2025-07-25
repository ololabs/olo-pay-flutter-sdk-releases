// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.Address

fun Address.toMap(): Map<String, Any> {
    return mapOf(
        DataKeys.PostalCodeKey to this.postalCode,
        DataKeys.CountryCodeKey to this.countryCode,
        DataKeys.Address1Key to this.address1,
        DataKeys.Address2Key to this.address2,
        DataKeys.Address3Key to this.address3,
        DataKeys.LocalityKey to this.locality,
        DataKeys.AdministrativeAreaKey to this.administrativeArea,
        DataKeys.SortingCodeKey to this.sortingCode
    )
}