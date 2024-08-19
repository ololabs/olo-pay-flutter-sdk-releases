// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.exceptions.GooglePayException
import com.olo.olopay.googlepay.GooglePayErrorType
import kotlin.Exception
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNotNull

class GooglePayExceptionExtensionTests {
    @Test
    fun testToMap_hasCorrectLength() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertEquals(3, map.size)
    }

    @Test
    fun testToMap_hasCorrectKeys() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertNotNull(map["errorMessage"])
        assertNotNull(map["googlePayErrorType"])
        assertNotNull(map["digitalWalletType"])
    }

    @Test
    fun testToMap_hasCorrectValues() {
        val map = GooglePayException(
            throwable = Exception("test error message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertEquals("java.lang.Exception: test error message", map["errorMessage"])
        assertEquals("InternalError", map["googlePayErrorType"])
        assertEquals("googlePay", map["digitalWalletType"])
    }
}
