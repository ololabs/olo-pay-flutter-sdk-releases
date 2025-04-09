// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.data.ICardFieldState
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test

class CardFieldStateExtensionTests {
    @Test
    fun toMap_hasCorrectLength() {
        assertEquals(5, MockCardFieldState().toMap().size)
    }

    @Test
    fun toMap_hasCorrectKeys() {
        val map = MockCardFieldState().toMap()

        assertNotNull(map["isValid"])
        assertNotNull(map["isFocused"])
        assertNotNull(map["isEmpty"])
        assertNotNull(map["wasEdited"])
        assertNotNull(map["wasFocused"])
    }

    @Test
    fun toMap_keysHaveCorrectValues() {
        val map1 = MockCardFieldState(
            isValid = true,
            isEmpty = false,
            isFocused = true,
            wasEdited = false,
            wasFocused = true,
        ).toMap()

        assertEquals(true, map1["isValid"])
        assertEquals(false, map1["isEmpty"])
        assertEquals(true, map1["isFocused"])
        assertEquals(false, map1["wasEdited"])
        assertEquals(true, map1["wasFocused"])

        val map2 = MockCardFieldState(
            isValid = false,
            isEmpty = true,
            isFocused = false,
            wasEdited = true,
            wasFocused = false,
        ).toMap()

        assertEquals(false, map2["isValid"])
        assertEquals(true, map2["isEmpty"])
        assertEquals(false, map2["isFocused"])
        assertEquals(true, map2["wasEdited"])
        assertEquals(false, map2["wasFocused"])
    }
}

class MockCardFieldState(
    override val isValid: Boolean = true,
    override val isEmpty: Boolean = true,
    override val isFocused: Boolean = true,
    override val wasEdited: Boolean = true,
    override val wasFocused: Boolean = true
) : ICardFieldState {}