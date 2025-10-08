// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.data

import com.olo.olopay.data.CardBrand
import com.olo.olopay.data.CardField
import com.olo.olopay.data.ICardFieldState

data class CustomErrorMessages constructor(
    val invalidCardNumber: String?,
    val emptyCardNumber: String?,
    val unsupportedCardNumber: String?,
    val invalidExpiration: String?,
    val emptyExpiration: String?,
    val invalidCvv: String?,
    val emptyCvv: String?,
    val invalidPostalCode: String?,
    val emptyPostalCode: String?
){
    constructor(customErrorMessagesMap: Map<*, *>): this(
        (customErrorMessagesMap[CardField.CardNumber.toString()] as? Map<*, *>)?.get(DataKeys.InvalidErrorKey) as? String,
        (customErrorMessagesMap[CardField.CardNumber.toString()] as? Map<*, *>)?.get(DataKeys.EmptyErrorKey) as? String,
        customErrorMessagesMap[DataKeys.UnsupportedCardErrorKey] as? String,
        (customErrorMessagesMap[CardField.Expiration.toString()] as? Map<*, *>)?.get(DataKeys.InvalidErrorKey) as? String,
        (customErrorMessagesMap[CardField.Expiration.toString()] as? Map<*, *>)?.get(DataKeys.EmptyErrorKey) as? String,
        (customErrorMessagesMap[CardField.Cvv.toString()] as? Map<*, *>)?.get(DataKeys.InvalidErrorKey) as? String,
        (customErrorMessagesMap[CardField.Cvv.toString()] as? Map<*, *>)?.get(DataKeys.EmptyErrorKey) as? String,
        (customErrorMessagesMap[CardField.PostalCode.toString()] as? Map<*, *>)?.get(DataKeys.InvalidErrorKey) as? String,
        (customErrorMessagesMap[CardField.PostalCode.toString()] as? Map<*, *>)?.get(DataKeys.EmptyErrorKey) as? String
    )

    constructor(invalidCvvError: String?, emptyCvvError: String?): this(
        null,
        null,
        null,
        null,
        null,
        invalidCvvError,
        emptyCvvError,
        null,
        null
    )

    fun getCustomErrorMessage(ignoreUneditedFieldErrors: Boolean, cardFields: Map<CardField, ICardFieldState>, cardBrand: CardBrand? = null): String? {
        val errorFields = getErrorFields(ignoreUneditedFieldErrors, cardFields)
        return when  {
            errorFields.containsKey(CardField.CardNumber) -> {
                val state = errorFields[CardField.CardNumber]!!
                if(state.isEmpty) {
                    emptyCardNumber
                } else if (cardBrand == CardBrand.Unsupported) {
                    unsupportedCardNumber
                } else {
                    invalidCardNumber
                }
            }
            errorFields.containsKey(CardField.Expiration) -> {
                if(errorFields[CardField.Expiration]!!.isEmpty) emptyExpiration else invalidExpiration
            }
            errorFields.containsKey(CardField.Cvv) -> {
                if (errorFields[CardField.Cvv]!!.isEmpty) emptyCvv else invalidCvv
            }
            errorFields.containsKey(CardField.PostalCode) -> {
                if (errorFields[CardField.PostalCode]!!.isEmpty) emptyPostalCode else invalidPostalCode
            }
            else -> {
                null
            }
        }
    }

    fun getErrorFields(ignoreUneditedFieldErrors: Boolean, cardFields: Map<CardField, ICardFieldState>): Map<CardField, ICardFieldState> {
        // Return all error fields regardless of state
        if (!ignoreUneditedFieldErrors)
            return cardFields.filterKeys {
                !cardFields[it]!!.isValid
            }

        return cardFields.filterKeys {
            val state = cardFields[it]!!
            !state.isValid && state.wasEdited && state.wasFocused
        }
    }
}
