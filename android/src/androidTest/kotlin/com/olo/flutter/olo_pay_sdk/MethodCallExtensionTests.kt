// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import com.olo.flutter.olo_pay_sdk.data.EmptyValueException
import com.olo.flutter.olo_pay_sdk.data.MissingKeyException
import com.olo.flutter.olo_pay_sdk.data.NullValueException
import com.olo.flutter.olo_pay_sdk.data.UnexpectedTypeException
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrThrow
import com.olo.flutter.olo_pay_sdk.extensions.getStringArgOrErrorResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import junit.framework.TestCase.assertEquals
import junit.framework.TestCase.fail
import org.junit.Test

import org.mockito.Mockito

class MethodCallExtensionTests {
    @Test
    fun getArgOrThrow_keyMissing_throwsMissingKeyException() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to "1.2.3"))

        try {
            call.getArgOrThrow<String>("bar")
            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            assertEquals("Missing key 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsNull_throwsNullValueException() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        try {
            call.getArgOrThrow<String>("foo")
            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            assertEquals("Value for 'foo' is null", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsIncorrectType_throwsUnexpectedTypeException() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to 2.0))

        try {
            call.getArgOrThrow<String>("foo")
            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            assertEquals("Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrThrow_keyExists_valueIsCorrectType_returnsArgValue() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getArgOrThrow<String>("foo")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("bar", argValue)
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyMissing_returnsDefaultValue() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getArgOrThrow<String>("bar", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("default", argValue)
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsNull_returnsDefaultValue() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        val argValue = try {
            call.getArgOrThrow<String>("foo", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("default", argValue)
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsIncorrectType_throwsUnexpectedTypeException() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to 2.0))

        try {
            call.getArgOrThrow<String>("foo", "default")
            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            assertEquals("Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrThrow_withDefaultValue_keyExists_valueIsCorrectType_returnsArgValue() {
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getArgOrThrow<String>("foo", "default")
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        assertEquals("bar", argValue)
    }

    @Test
    fun getArgOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "1.2.3"))

        try {
            call.getArgOrErrorResult<String>(
                "bar",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'bar'",
                null
            )

            assertEquals("Test: Missing parameter 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIsNull_returnsMissingParameter_throwsNullValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        try {
            call.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'foo'",
                null
            )

            assertEquals("Test: Missing parameter 'foo'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to true))

        try {
            call.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrErrorResult_argValueIsCorrectType_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getArgOrErrorResult<String>(
                "foo",
                "Test",
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "1.2.3"))

        try {
            val argValue = call.getArgOrErrorResult<String>(
                "bar",
                "default",
                "Test",
                mockResult
            )

            Mockito.verifyNoInteractions(mockResult)
            assertEquals("default", argValue)
        } catch(e: Exception) {
            fail("Exception should not be thrown")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argsValueIsNull_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        try {
            val argValue = call.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )

            Mockito.verifyNoInteractions(mockResult)
            assertEquals("default", argValue)
        } catch(e: Exception) {
            fail("Exception should not be thrown")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to true))

        try {
            call.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getArgOrErrorResult_withDefaultValue_argValueIsCorrectType_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getArgOrErrorResult<String>(
                "foo",
                "default",
                "Test",
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "1.2.3"))

        try {
            call.getStringArgOrErrorResult(
                "bar",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: MissingKeyException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'bar'",
                null
            )

            assertEquals("Test: Missing parameter 'bar'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type MissingKeyException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_argValueIsNull_returnsMissingParameter_throwsNullValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: NullValueException) {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "Test: Missing parameter 'foo'",
                null
            )

            assertEquals("Test: Missing parameter 'foo'", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type NullValueException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to true))

        try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueNotAccepted_argValueIsEmpty_returnsInvalidParameter_throwsEmptyValueException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to ""))

        try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                false,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: EmptyValueException) {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "Test: Value for 'foo' cannot be empty",
                null
            )

            assertEquals("Test: Value for 'foo' cannot be empty", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type EmptyValueException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueAccepted_argValueIsEmpty_returnsEmptyString() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to ""))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_emptyValueAccepted_argValueNotEmpty_returnsArg() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "1.2.3"))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "bar",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argValueIsNull_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to null))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeException() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to true))

        try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )

            fail("Exception should be thrown")
        } catch (e: UnexpectedTypeException) {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Test: Value for 'foo' is not of type String",
                null
            )

            assertEquals("Test: Value for 'foo' is not of type String", e.message)
        } catch (e: Exception) {
            fail("Exception should be of type UnexpectedTypeException")
        }
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueIsEmpty_returnsDefaultValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to ""))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("default", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                false,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueAccepted_argValueIsEmpty_returnsEmptyString() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to ""))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("", argValue)
    }

    @Test
    fun getStringArgOrErrorResult_withDefaultValue_emptyValueAccepted_argValueNotEmpty_returnsArgValue() {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val call = MethodCall("someRandomMethod", mapOf("foo" to "bar"))

        val argValue = try {
            call.getStringArgOrErrorResult(
                "foo",
                "default",
                "Test",
                true,
                mockResult
            )
        } catch (e: Exception) {
            fail("Exception should not be thrown")
        }

        Mockito.verifyNoInteractions(mockResult)
        assertEquals("bar", argValue)
    }
}