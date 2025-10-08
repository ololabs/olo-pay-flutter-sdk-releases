// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.data.Address
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue

class AddressExtensionTests {
    @Test
    fun toMap_withMinAddress_hasCorrectLength() {
        assertEquals(8, minimumAddress.toMap().size)
    }

    @Test
    fun toMap_withMinAddress_hasCorrectKeys() {
        val map = minimumAddress.toMap()

        assertTrue(map.containsKey("postalCode"))
        assertTrue(map.containsKey("countryCode"))
        assertTrue(map.containsKey("address1"))
        assertTrue(map.containsKey("address2"))
        assertTrue(map.containsKey("address3"))
        assertTrue(map.containsKey("locality"))
        assertTrue(map.containsKey("administrativeArea"))
        assertTrue(map.containsKey("sortingCode"))
    }

    @Test
    fun toMap_withMinAddress_hasCorrectValues() {
        val map = minimumAddress.toMap()

        assertEquals("12345", map["postalCode"])
        assertEquals("US", map["countryCode"])
        assertEquals("", map["address1"])
        assertEquals("", map["address2"])
        assertEquals("", map["address3"])
        assertEquals("", map["locality"])
        assertEquals("", map["administrativeArea"])
        assertEquals("", map["sortingCode"])
    }

    @Test
    fun toMap_withFullAddress_hasCorrectLength() {
        assertEquals(8, fullAddress.toMap().size)
    }

    @Test
    fun toMap_withFullAddress_hasCorrectKeys() {
        val map = fullAddress.toMap()

        assertTrue(map.containsKey("postalCode"))
        assertTrue(map.containsKey("countryCode"))
        assertTrue(map.containsKey("address1"))
        assertTrue(map.containsKey("address2"))
        assertTrue(map.containsKey("address3"))
        assertTrue(map.containsKey("locality"))
        assertTrue(map.containsKey("administrativeArea"))
        assertTrue(map.containsKey("sortingCode"))
    }

    @Test
    fun toMap_withFullAddress_hasCorrectValues() {
        val map = fullAddress.toMap()

        assertEquals("54321", map["postalCode"])
        assertEquals("CA", map["countryCode"])
        assertEquals("c/o Ron Idaho", map["address1"])
        assertEquals("123 ABC Street", map["address2"])
        assertEquals("Suite 2", map["address3"])
        assertEquals("New York City", map["locality"])
        assertEquals("NY", map["administrativeArea"])
        assertEquals("123", map["sortingCode"])
    }

    companion object {
        val minimumAddress = Address(
            postalCode = "12345",
            countryCode = "US"
        )

        val fullAddress = Address(
            postalCode = "54321",
            countryCode = "CA",
            address1 = "c/o Ron Idaho",
            address2 = "123 ABC Street",
            address3 = "Suite 2",
            locality = "New York City",
            administrativeArea = "NY",
            sortingCode = "123"
        )
    }
}