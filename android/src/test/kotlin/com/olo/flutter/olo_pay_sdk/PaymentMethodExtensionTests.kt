// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import android.os.Parcel
import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.data.CardBrand
import com.olo.olopay.data.IPaymentMethod
import com.olo.olopay.data.OloPayEnvironment
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull


class PaymentMethodExtensionTests {

    @Test
    fun toMap_hasCorrectLength() {
        assertEquals(9, MockPaymentMethod().toMap().size)
    }

    @Test
    fun toMap_hasCorrectKeys() {
        val map = MockPaymentMethod().toMap()

        assertNotNull(map["cardType"])
        assertNotNull(map["countryCode"])
        assertNotNull(map["productionEnvironment"])
        assertNotNull(map["expMonth"])
        assertNotNull(map["expYear"])
        assertNotNull(map["id"])
        assertNotNull(map["isDigitalWallet"])
        assertNotNull(map["last4"])
        assertNotNull(map["postalCode"])
    }

    @Test
    fun toMap_hasCorrectValues() {
        val map = MockPaymentMethod().toMap()

        assertEquals("Visa", map["cardType"])
        assertEquals("US", map["countryCode"])
        assertEquals(false, map["productionEnvironment"])
        assertEquals(1, map["expMonth"])
        assertEquals(2001, map["expYear"])
        assertEquals("pm_1234", map["id"])
        assertEquals(false, map["isDigitalWallet"])
        assertEquals("1234", map["last4"])
        assertEquals("12345", map["postalCode"])
    }

}

class MockPaymentMethod(
    override val cardType: CardBrand? = CardBrand.Visa,
    override val country: String? = "US",
    override val environment: OloPayEnvironment = OloPayEnvironment.Test,
    override val expirationMonth: Int? = 1,
    override val expirationYear: Int? = 2001,
    override val id: String? = "pm_1234",
    override val isGooglePay: Boolean = false,
    override val last4: String? = "1234",
    override val postalCode: String? = "12345"
) : IPaymentMethod {
    override fun describeContents(): Int {
        // Not needed for testing
        return 0
    }

    override fun writeToParcel(p0: Parcel, p1: Int) {
        // Not needed for testing
    }
}