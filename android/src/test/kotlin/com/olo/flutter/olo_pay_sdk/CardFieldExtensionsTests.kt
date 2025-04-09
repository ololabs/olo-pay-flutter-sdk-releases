// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.olopay.data.CardField
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import com.olo.flutter.olo_pay_sdk.extensions.from

class CardFieldExtensionsTests {
    @Test
    fun from_CardNumberString_ReturnsCardNumberField() {
        assertEquals(CardField.CardNumber, CardField.from("CardNumber"))
    }

    @Test
    fun from_ExpirationString_ReturnsExpirationField() {
        assertEquals(CardField.Expiration, CardField.from("Expiration"))
    }

    @Test
    fun from_CvvString_ReturnsCvvField() {
        assertEquals(CardField.Cvv, CardField.from("Cvv"))
    }

    @Test
    fun from_PostalCodeString_ReturnsPostalCodeField() {
        assertEquals(CardField.PostalCode, CardField.from("PostalCode"))
    }

    @Test
    fun from_EmptyString_ReturnsCardNumberField() {
        assertEquals(CardField.CardNumber, CardField.from(""))
    }

    @Test
    fun from_UnexpectedString_ReturnsCardNumberField() {
        assertEquals(CardField.CardNumber, CardField.from("FooBar"))
    }
}