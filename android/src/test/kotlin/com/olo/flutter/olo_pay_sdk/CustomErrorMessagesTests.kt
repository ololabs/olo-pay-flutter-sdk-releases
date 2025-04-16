// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.data.CustomErrorMessages
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.data.CardBrand
import com.olo.olopay.data.CardField
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class CustomErrorMessagesTests {

    @Test
    fun getCustomErrorMessage_cardNumberField_withCustomErrorMessagesDefined_returnsCustomErrorMessages() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card",
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState)
        )

        assertEquals("Empty card", emptyMessage)
        assertEquals("Invalid card", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cardNumberField_missingCustomErrorMessages_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    null to null
                    // DataKeys.EmptyErrorKey to "Empty card", removed for testing purposes
                    // DataKeys.InvalidErrorKey to "Invalid card" removed for testing purposes
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card",
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cardNumberField_customErrorMessagesNull_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to null,
                    DataKeys.InvalidErrorKey to null,
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card",
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cardNumberField_emptyCustomErrorMessages_returnsEmptyStrings() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "",
                    DataKeys.InvalidErrorKey to ""
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card",
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState)
        )

        assertEquals("", emptyMessage)
        assertEquals("", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_unsupportedCardBrand_withCustomErrorMessageDefined_returnsCustomErrorMessage() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card",
            )
        )

        val message = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState),
            CardBrand.Unsupported
        )

        assertEquals("Unsupported card", message)
    }

    @Test
    fun getCustomErrorMessage_unsupportedCardBrand_missingCustomErrorMessage_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                // DataKeys.UnsupportedCardErrorKey to "Unsupported card", removed for testing purposes
            )
        )

        val message = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState),
            CardBrand.Unsupported
        )

        assertEquals(null, message)
    }

    @Test
    fun getCustomErrorMessage_unsupportedCardBrand_customErrorMessageNull_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to null,
            )
        )

        val message = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState),
            CardBrand.Unsupported
        )

        assertEquals(null, message)
    }

    @Test
    fun getCustomErrorMessage_unsupportedCardBrand_emptyCustomErrorMessage_returnsEmptyString() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "",
            )
        )

        val message = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.CardNumber to invalidFieldState),
            CardBrand.Unsupported
        )

        assertEquals("", message)
    }

    @Test
    fun getCustomErrorMessage_expirationField_withCustomErrorMessagesDefined_returnsCustomErrorMessages() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to invalidFieldState)
        )

        assertEquals("Empty expiration", emptyMessage)
        assertEquals("Invalid expiration", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_expirationField_missingCustomErrorMessages_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    null to null
                    // DataKeys.EmptyErrorKey to "Empty expiration", removed for testing purposes
                    // DataKeys.InvalidErrorKey to "Invalid expiration", removed for testing purposes
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_expirationField_customErrorMessagesNull_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to null,
                    DataKeys.InvalidErrorKey to null,
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_expirationField_emptyCustomErrorMessages_returnsEmptyStrings() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "",
                    DataKeys.InvalidErrorKey to ""
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Expiration to invalidFieldState)
        )

        assertEquals("", emptyMessage)
        assertEquals("", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cvvField_withCustomErrorMessagesDefined_returnsCustomErrorMessages() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv"
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to invalidFieldState)
        )

        assertEquals("Empty cvv", emptyMessage)
        assertEquals("Invalid cvv", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cvvField_missingCustomErrorMessages_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    null to null
                    // DataKeys.EmptyErrorKey to "Empty cvv", removed for testing purposes
                    // DataKeys.InvalidErrorKey to "Invalid cvv", removed for testing purposes
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cvvField_customErrorMessagesNull_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to null,
                    DataKeys.InvalidErrorKey to null
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_cvvField_emptyCustomErrorMessages_returnsEmptyStrings() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid Expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "",
                    DataKeys.InvalidErrorKey to ""
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.Cvv to invalidFieldState)
        )

        assertEquals("", emptyMessage)
        assertEquals("", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_postalCodeField_withCustomErrorMessagesDefined_returnsCustomErrorMessages() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv",
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code"
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to invalidFieldState)
        )

        assertEquals("Empty postal code", emptyMessage)
        assertEquals("Invalid postal code", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_postalCodeField_missingCustomErrorMessages_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv",
                ),
                CardField.PostalCode.toString() to mapOf(
                    null to null
                    // DataKeys.EmptyErrorKey to "Empty postal code", removed for testing purposes
                    // DataKeys.InvalidErrorKey to "Invalid postal code", removed for testing purposes
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_postalCodeField_customErrorMessagesNull_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv",
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to null,
                    DataKeys.InvalidErrorKey to null,
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to invalidFieldState)
        )

        assertEquals(null, emptyMessage)
        assertEquals(null, invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_postalCodeField_emptyCustomErrorMessages_returnsEmptyStrings() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv",
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "",
                    DataKeys.InvalidErrorKey to "",
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val emptyMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to emptyFieldState)
        )

        val invalidMessage = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf(CardField.PostalCode to invalidFieldState)
        )

        assertEquals("", emptyMessage)
        assertEquals("", invalidMessage)
    }

    @Test
    fun getCustomErrorMessage_emptyCardFieldMap_returnsNull() {
        val customErrorMessages = CustomErrorMessages(
            mapOf(
                CardField.CardNumber.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty card",
                    DataKeys.InvalidErrorKey to "Invalid card"
                ),
                CardField.Expiration.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty expiration",
                    DataKeys.InvalidErrorKey to "Invalid expiration"
                ),
                CardField.Cvv.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty cvv",
                    DataKeys.InvalidErrorKey to "Invalid cvv",
                ),
                CardField.PostalCode.toString() to mapOf(
                    DataKeys.EmptyErrorKey to "Empty postal code",
                    DataKeys.InvalidErrorKey to "Invalid postal code",
                ),
                DataKeys.UnsupportedCardErrorKey to "Unsupported card"
            )
        )

        val message = customErrorMessages.getCustomErrorMessage(
            false,
            mapOf()
        )

        assertEquals(null, message)
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsTrue_cardNumberField_notValidWasEditedWasFocused_returnsCardNumberField() {
        val ignoreUneditedFields = true

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to MockCardFieldState(
                    isEmpty = true,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.Expiration to validFieldState,
                CardField.Cvv to validFieldState,
                CardField.PostalCode to validFieldState,
            )
        )

        assertEquals(errorFields.size, 1)
        assertTrue(errorFields.containsKey(CardField.CardNumber))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsTrue_cvvAndPostalCodeFields_invalidWasEditedWasFocused_returnsCvvAndPostalCodeFields() {
        val ignoreUneditedFields = true

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to  MockCardFieldState(
                    isEmpty = false,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = false,
                ),
                CardField.Expiration to MockCardFieldState(
                    isEmpty = true,
                    isValid = false,
                    isFocused = false,
                    wasEdited = false,
                    wasFocused = true,
                ),
                CardField.Cvv to MockCardFieldState(
                    isEmpty = false,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.PostalCode to MockCardFieldState(
                    isEmpty = true,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
            )
        )

        assertEquals(errorFields.size, 2)
        assertTrue(errorFields.containsKey(CardField.Cvv))
        assertTrue(errorFields.containsKey(CardField.PostalCode))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsTrue_allFields_invalidWasEditedWasFocused_returnsAllFields() {
        val ignoreUneditedFields = true

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to MockCardFieldState(
                    isEmpty = false,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.Expiration to MockCardFieldState(
                    isEmpty = false,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.Cvv to MockCardFieldState(
                    isEmpty = true,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.PostalCode to MockCardFieldState(
                    isEmpty = true,
                    isValid = false,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
            )
        )

        assertEquals(errorFields.size, 4)
        assertTrue(errorFields.containsKey(CardField.CardNumber))
        assertTrue(errorFields.containsKey(CardField.Expiration))
        assertTrue(errorFields.containsKey(CardField.Cvv))
        assertTrue(errorFields.containsKey(CardField.PostalCode))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsTrue_noFields_invalidWasEditedWasFocused_returnsNoFields() {
        val ignoreUneditedFields = true

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to validFieldState,
                CardField.Expiration to MockCardFieldState(
                    isEmpty = true,
                    isValid = true,
                    isFocused = false,
                    wasEdited = false,
                    wasFocused = true,
                ),
                CardField.Cvv to MockCardFieldState(
                    isEmpty = false,
                    isValid = true,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
                CardField.PostalCode to MockCardFieldState(
                    isEmpty = true,
                    isValid = true,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true,
                ),
            )
        )

        assertEquals(errorFields.size, 0)
        assertTrue(errorFields.isEmpty())
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsFalse_allValidFields_returnsEmptyMap() {
        val ignoreUneditedFields = false

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to validFieldState,
                CardField.Expiration to validFieldState,
                CardField.Cvv to validFieldState,
                CardField.PostalCode to validFieldState,
            )
        )

        assertTrue(errorFields.isEmpty())
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsFalse_onlyNumberFieldInvalid_returnsOnlyNumberField() {
        val ignoreUneditedFields = false

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to invalidFieldState,
                CardField.Expiration to validFieldState,
                CardField.Cvv to validFieldState,
                CardField.PostalCode to validFieldState,
            )
        )

        assertEquals(1, errorFields.size)
        assertTrue(errorFields.containsKey(CardField.CardNumber))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsFalse_expirationAndCvvFieldsInvalid_returnsCorrectErrorFields() {
        val ignoreUneditedFields = false

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to validFieldState,
                CardField.Expiration to invalidFieldState,
                CardField.Cvv to invalidFieldState,
                CardField.PostalCode to validFieldState,
            )
        )

        assertEquals(2, errorFields.size)
        assertTrue(errorFields.containsKey(CardField.Expiration))
        assertTrue(errorFields.containsKey(CardField.Cvv))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsFalse_allFieldsInvalid_returnsAllErrorFields() {
        val ignoreUneditedFields = false

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to invalidFieldState,
                CardField.Expiration to invalidFieldState,
                CardField.Cvv to invalidFieldState,
                CardField.PostalCode to MockCardFieldState(
                    isEmpty = false,
                    isValid = false,
                    isFocused = true,
                    wasEdited = true,
                    wasFocused = true
                ),
            )
        )

        assertEquals(4, errorFields.size)
        assertTrue(errorFields.containsKey(CardField.CardNumber))
        assertTrue(errorFields.containsKey(CardField.Expiration))
        assertTrue(errorFields.containsKey(CardField.Cvv))
        assertTrue(errorFields.containsKey(CardField.PostalCode))
    }

    @Test
    fun getErrorFields_ignoreUneditedFieldsFalse_numberFieldInvalid_expirationWasEditedAndWasFocused_returnsOnlyCardField() {
        val ignoreUneditedFields = false

        val customErrorMessages = CustomErrorMessages(mapOf(CardField.CardNumber to ""))

        val errorFields = customErrorMessages.getErrorFields(
            ignoreUneditedFields,
            mapOf(
                CardField.CardNumber to invalidFieldState,
                CardField.Expiration to MockCardFieldState(
                    isEmpty = false,
                    isValid = true,
                    isFocused = false,
                    wasEdited = true,
                    wasFocused = true
                ),
                CardField.Cvv to validFieldState,
                CardField.PostalCode to validFieldState
            )
        )

        assertEquals(1, errorFields.size )
        assertTrue(errorFields.containsKey(CardField.CardNumber))
    }

    val invalidFieldState = MockCardFieldState(
        isEmpty = false,
        isValid = false,
        isFocused = false,
        wasEdited = true,
        wasFocused = true
    )

    val emptyFieldState = MockCardFieldState(
        isEmpty = true,
        isValid = false,
        isFocused = false,
        wasEdited = false,
        wasFocused = false,
    )

    val validFieldState = MockCardFieldState()
}
