// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.googlepay.GooglePayErrorType
import com.olo.olopay.googlepay.GooglePayException
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotNull
import org.junit.jupiter.api.Test
import kotlin.Exception

class GooglePayExceptionExtensionTests {
    @Test
    fun toMap_hasCorrectLength() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertEquals(3, map.size)
    }

    @Test
    fun toMap_hasCorrectKeys() {
        val map = GooglePayException(
            throwable = Exception("message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertNotNull(map["errorMessage"])
        assertNotNull(map["digitalWalletErrorCode"])
        assertNotNull(map["digitalWalletType"])
    }

    @Test
    fun toMap_hasCorrectValues() {
        val map = GooglePayException(
            throwable = Exception("test error message"),
            errorType = GooglePayErrorType.InternalError,
        ).toMap()

        assertEquals("java.lang.Exception: test error message", map["errorMessage"])
        assertEquals("InternalError", map["digitalWalletErrorCode"])
        assertEquals("googlePay", map["digitalWalletType"])
    }
}
