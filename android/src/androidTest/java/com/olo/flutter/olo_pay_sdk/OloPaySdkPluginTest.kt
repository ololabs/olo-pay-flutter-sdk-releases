// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import android.app.Application
import androidx.test.platform.app.InstrumentationRegistry
import com.olo.flutter.olo_pay_sdk.utils.MethodFinishedCallback
import com.olo.olopay.api.IOloPayApiInitializer
import com.olo.olopay.data.OloPayEnvironment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class OloPaySdkPluginTest {
    private val testApplication: Application
        get() = InstrumentationRegistry.getInstrumentation().targetContext.applicationContext as Application

    private val initializeGooglePayBaseError = "Unable to initialize Google Pay"
    private val initializeMetaDataError = "Unable to initialize metadata"
    private val changeGooglePayVendorBaseError = "Unable to change Google Pay Country"
    private val getDigitalWalletPaymentMethodBaseError = "Unable to create payment method"
    private var _plugin: OloPaySdkPlugin? = null

    private val plugin: OloPaySdkPlugin
        get() = _plugin!!

    @Before
    fun setup() {
        _plugin = OloPaySdkPlugin()
        plugin.appContext = testApplication
    }

    @After
    fun teardown() {
        _plugin = null
        IOloPayApiInitializer.sdkWrapperInfo = null
    }

    @Test
    fun initializeOloPay_withoutEnvironmentArg_sdkInitialized_environmentDefaultsToProduction() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertTrue(plugin._sdkInitialized)
            assertEquals(OloPayEnvironment.Production, plugin.environment)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", null)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeOloPay_withFalseEnvironmentArg_sdkInitialized_environmentSetToTest() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertTrue(plugin._sdkInitialized)
            assertEquals(OloPayEnvironment.Test, plugin.environment)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", mapOf("productionEnvironment" to false))
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeOloPay_withTrueEnvironmentArg_sdkInitialized_environmentSetToProduction() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertTrue(plugin._sdkInitialized)
            assertEquals(OloPayEnvironment.Production, plugin.environment)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", mapOf("productionEnvironment" to true))
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeOloPay_environmentArgNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "Unable to initialize OloPaySdk: Value for 'productionEnvironment' is not of type Boolean",
                null
            )
            assertFalse(plugin._sdkInitialized)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", mapOf("productionEnvironment" to "true"))
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeOloPay_environmentArgNull_sdkInitialized_environmentSetToProduction() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertTrue(plugin._sdkInitialized)
            assertEquals(OloPayEnvironment.Production, plugin.environment)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", mapOf("productionEnvironment" to null))
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_metadataContainsCorrectValues_wrapperInfoSetCorrectly_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to "3.2.1", // non default value
            "buildType" to "public" // non default value
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("3.2.1", IOloPayApiInitializer.sdkWrapperInfo?.version)
            assertEquals("public", IOloPayApiInitializer.sdkWrapperInfo?.buildType)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_emptyHybridVersion_setsDefaultHybridVersion_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to "",
            "buildType" to "internal"
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("0.0.0", IOloPayApiInitializer.sdkWrapperInfo?.version)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_nullHybridVersion_setsDefaultHybridVersion_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to null,
            "buildType" to "internal"
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("0.0.0", IOloPayApiInitializer.sdkWrapperInfo?.version)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_missingHybridVersion_setsDefaultHybridVersion_returnsSuccess() = runBlocking {
        val map = mapOf(
            // "version" to "" intentionally removed from args map
            "buildType" to "internal"
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("0.0.0", IOloPayApiInitializer.sdkWrapperInfo?.version)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_hybridVersionNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val map = mapOf(
            "version" to 1.23,
            "buildType" to "internal"
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeMetaDataError}: Value for 'version' is not of type String",
                null
            )
            assertNull(IOloPayApiInitializer.sdkWrapperInfo)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_emptyHybridBuildType_setsDefaultHybridBuildType_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to "1.2.3",
            "buildType" to ""
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("internal", IOloPayApiInitializer.sdkWrapperInfo?.buildType)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_nullHybridBuildType_setsDefaultHybridBuildType_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to "1.2.3",
            "buildType" to null
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("internal", IOloPayApiInitializer.sdkWrapperInfo?.buildType)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_missingHybridBuildType_setsDefaultHybridBuildType_returnsSuccess() = runBlocking {
        val map = mapOf(
            "version" to "1.2.3",
            // "buildType" to "" intentionally removed from args map
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertEquals("internal", IOloPayApiInitializer.sdkWrapperInfo?.buildType)
            assertEquals("flutter", IOloPayApiInitializer.sdkWrapperInfo?.platform)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeMetadata_hybridBuildTypeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val map = mapOf(
            "version" to "1.2.3",
            "buildType" to true
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeMetaDataError}: Value for 'buildType' is not of type String",
                null
            )
            assertNull(IOloPayApiInitializer.sdkWrapperInfo)
            expectation.fulfill()
        }

        val call = MethodCall("initializeMetadata", map)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun isSdkInitialized_sdkInitialized_returnsTrue() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        waitForInitialization()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(true)
            assertTrue(plugin._sdkInitialized)
            expectation.fulfill()
        }

        val call = MethodCall("isInitialized", null)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun isSdkInitialized_sdkNotInitialized_returnsFalse() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(false)
            assertFalse(plugin._sdkInitialized)
            expectation.fulfill()
        }

        val call = MethodCall("isInitialized", null)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "SdkUninitialized",
                "${initializeGooglePayBaseError}: Olo Pay SDK has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_emptyCountryCode_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${initializeGooglePayBaseError}: Value for 'countryCode' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_nullCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to null,
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeGooglePayBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_missingCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            // "countryCode" to "" intentionally removed from args map
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeGooglePayBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_countryCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "countryCode" to true,
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'countryCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_emptyMerchantName_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${initializeGooglePayBaseError}: Value for 'merchantName' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_nullMerchantName_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to null,
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeGooglePayBaseError}: Missing parameter 'merchantName'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_missingMerchantName_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            // "merchantName" to "" intentionally removed from args map
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeGooglePayBaseError}: Missing parameter 'merchantName'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_merchantNameNotString_returnsUnexpectedParameterTypeError() = runBlocking{
         val args = mapOf(
            "countryCode" to "US",
            "merchantName" to 123,
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'merchantName' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_googlePayProductionEnvironmentNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to "true",
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'googlePayProductionEnvironment' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_fullAddressFormatNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to "false",
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'fullAddressFormat' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_existingPaymentMethodRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to "false",
            "emailRequired" to false,
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'existingPaymentMethodRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_emailRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to "false",
            "phoneNumberRequired" to false,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'emailRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_phoneNumberRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "googlePayProductionEnvironment" to false,
            "fullAddressFormat" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to "false",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeGooglePayBaseError}: Value for 'phoneNumberRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeGooglePay_sdkInitialized_withValidGooglePayParams_returnsInvalidGooglePaySetupError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
            "productionEnvironment" to false,
            "existingPaymentMethodRequired" to false,
            "emailRequired" to false,
            "phoneNumberRequired" to false,
            "addressFormat" to false
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidGooglePaySetup",
                "${initializeGooglePayBaseError}: AndroidManifest missing com.google.android.gms.wallet.api.enabled entry",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeGooglePay", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun isGooglePayReady_googlePayNotInitialized_returnsFalse() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(false)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("isDigitalWalletReady", null)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "SdkUninitialized",
                "${changeGooglePayVendorBaseError}: Olo Pay SDK has not been initialized",
                null)
            assertFalse(plugin._sdkInitialized)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_emptyCountryCode_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "",
            "merchantName" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${changeGooglePayVendorBaseError}: Value for 'countryCode' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_nullCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to null,
            "merchantName" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${changeGooglePayVendorBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_missingCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            // "countryCode" to "" intentionally removed from args map
            "merchantName" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${changeGooglePayVendorBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_countryCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "countryCode" to true,
            "merchantName" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${changeGooglePayVendorBaseError}: Value for 'countryCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_emptyMerchantName_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${changeGooglePayVendorBaseError}: Value for 'merchantName' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_nullMerchantName_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to null,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${changeGooglePayVendorBaseError}: Missing parameter 'merchantName'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_missingMerchantName_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            // "merchantName" to "" intentionally removed from args map
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${changeGooglePayVendorBaseError}: Missing parameter 'merchantName'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_merchantNameNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to true,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${changeGooglePayVendorBaseError}: Value for 'merchantName' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun changeGooglePayVendor_sdkInitialized_googlePayNotInitialized_returnGooglePayUninitializedError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "merchantName" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "GooglePayUninitialized",
                "${changeGooglePayVendorBaseError}: Google Pay not initialized",
                null
            )
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("changeGooglePayVendor", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkNotInitialized_googlePayNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "SdkUninitialized",
                "${getDigitalWalletPaymentMethodBaseError}: Olo Pay SDK has not been initialized",
                null)
            assertFalse(plugin._sdkInitialized)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNull_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "amount" to null,
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'amount'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountMissing_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            // "amount" to 1.23 intentionally removed from args map
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'amount'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNotDouble_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "amount" to "1.23",
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'amount' is not of type Double",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNegative_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "amount" to -1.23,
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'amount' cannot be negative",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountPositive_returnsGooglePayNotReadyError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "GooglePayNotReady",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay isn't ready yet",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountZero_returnsGooglePayNotReadyError() = runBlocking {
        val args = mapOf(
            "amount" to 0.0,
            "currencyCode" to "USD",
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "GooglePayNotReady",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay isn't ready yet",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "currencyCode" to 123,
            "currencyMultiplier" to 100
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'currencyCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun getDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_currencyMultiplierNotInt_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "currencyCode" to "US",
            "currencyMultiplier" to 1.0
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'currencyMultiplier' is not of type Integer",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    private fun waitForInitialization(isProductionEnvironment: Boolean = false) = runBlocking {
        val args = mapOf(
            "productionEnvironment" to isProductionEnvironment,
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation(failMessage = "Initialize expectation not fulfilled")

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).success(null)
            assertTrue(plugin._sdkInitialized)
            expectation.fulfill()
        }

        val call = MethodCall("initialize", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }
}


