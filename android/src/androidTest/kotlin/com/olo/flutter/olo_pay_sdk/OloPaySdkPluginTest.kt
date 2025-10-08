// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import android.app.Application
import androidx.test.platform.app.InstrumentationRegistry
import com.olo.flutter.olo_pay_sdk.utils.MethodFinishedCallback
import com.olo.olopay.api.IOloPayApiInitializer
import com.olo.olopay.data.OloPayEnvironment
import com.olo.olopay.googlepay.GooglePayConfig
import com.olo.olopay.googlepay.GooglePayEnvironment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import junit.framework.TestCase.assertEquals
import junit.framework.TestCase.assertFalse
import junit.framework.TestCase.assertNull
import junit.framework.TestCase.assertTrue
import kotlinx.coroutines.runBlocking
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class OloPaySdkPluginTest {
    private val testApplication: Application
        get() = InstrumentationRegistry.getInstrumentation().targetContext.applicationContext as Application

    private val initializeDigitalWalletBaseError = "Unable to initialize Google Pay"
    private val initializeMetaDataError = "Unable to initialize metadata"
    private val updateGooglePayConfigBaseError = "Unable to update the Google Pay configuration"
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
    fun initializeDigitalWallet_sdkNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "SdkUninitialized",
                "${initializeDigitalWalletBaseError}: Olo Pay SDK has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_emptyCountryCode_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "",
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${initializeDigitalWalletBaseError}: Value for 'countryCode' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_nullCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to null,
            "companyLabel" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeDigitalWalletBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_missingCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            // "countryCode" to "" intentionally removed from args map
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeDigitalWalletBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_countryCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to true,
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'countryCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_currencyCodeUnsupported_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "currencyCode" to "MXN"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: MXN is not supported",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "currencyCode" to 1.23
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'currencyCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_emptyCompanyLabel_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to ""
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${initializeDigitalWalletBaseError}: Value for 'companyLabel' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_nullCompanyLabel_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to null
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeDigitalWalletBaseError}: Missing parameter 'companyLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_missingCompanyLabel_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US"
            // "companyLabel" to "" intentionally removed from args map
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${initializeDigitalWalletBaseError}: Missing parameter 'companyLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_companyLabelNotString_returnsUnexpectedParameterTypeError() = runBlocking{
         val args = mapOf(
             "googlePayProductionEnvironment" to false,
             "countryCode" to "US",
            "companyLabel" to 123
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'companyLabel' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_digitalWalletsProductionEnvironmentNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to "true",
            "countryCode" to "US",
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'googlePayProductionEnvironment' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_existingPaymentMethodRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "existingPaymentMethodRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'existingPaymentMethodRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_emailRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "emailRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'emailRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_phoneNumberRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "phoneNumberRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'phoneNumberRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_fullBillingAddressRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "fullBillingAddressRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'fullBillingAddressRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_fullNameRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "fullNameRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'fullNameRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_currencyMultiplierNotInt_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "countryCode" to "US",
            "googlePayProductionEnvironment" to false,
            "companyLabel" to "Test Merchant",
            "currencyMultiplier" to "123"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${initializeDigitalWalletBaseError}: Value for 'currencyMultiplier' is not of type Integer",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun initializeDigitalWallet_sdkInitialized_walletNotEnabledInManifest_withValidGooglePayConfig_returnsInvalidDigitalWalletsSetupError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
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
                "${initializeDigitalWalletBaseError}: AndroidManifest missing com.google.android.gms.wallet.api.enabled entry",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("initializeDigitalWallet", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun isDigitalWalletReady_digitalWalletsNotInitialized_returnsFalse() = runBlocking {
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
    fun isDigitalWalletReady_googlePayInitialized_digitalWalletsNotReady_returnsFalse() = runBlocking {
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin._googlePayConfig = GooglePayConfig(
            environment = GooglePayEnvironment.Test,
            companyName = "Foobar",
            companyCountryCode = "US"
        )

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
    fun updateDigitalWalletConfiguration_sdkNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
        )

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "SdkUninitialized",
                "${updateGooglePayConfigBaseError}: Olo Pay SDK has not been initialized",
                null)
            assertFalse(plugin._sdkInitialized)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_emptyCountryCode_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "",
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${updateGooglePayConfigBaseError}: Value for 'countryCode' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_nullCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to null,
            "companyLabel" to "Test Merchant",
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${updateGooglePayConfigBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_missingCountryCode_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            // "countryCode" to "" intentionally removed from args map
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${updateGooglePayConfigBaseError}: Missing parameter 'countryCode'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_countryCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to true,
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'countryCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_currencyCodeUnsupported_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "currencyCode" to "MXN"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: MXN is not supported",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "currencyCode" to 1.23
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'currencyCode' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_emptyCompanyLabel_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to ""
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${updateGooglePayConfigBaseError}: Value for 'companyLabel' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_nullCompanyLabel_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to null
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${updateGooglePayConfigBaseError}: Missing parameter 'companyLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_missingCompanyLabel_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US"
            // "companyLabel" to "" intentionally removed from args map
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${updateGooglePayConfigBaseError}: Missing parameter 'companyLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_companyLabelNotString_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to 123
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'companyLabel' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_googlePayProductionEnvironmentNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to "true",
            "countryCode" to "US",
            "companyLabel" to "Test Merchant"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'googlePayProductionEnvironment' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_existingPaymentMethodRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "existingPaymentMethodRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'existingPaymentMethodRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_emailRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "emailRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'emailRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_phoneNumberRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "phoneNumberRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'phoneNumberRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_fullBillingAddressRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "fullBillingAddressRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'fullBillingAddressRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_fullNameRequiredNotBoolean_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "fullNameRequired" to "false"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'fullNameRequired' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_currencyMultiplierNotInt_returnsUnexpectedParameterTypeError() = runBlocking{
        val args = mapOf(
            "googlePayProductionEnvironment" to false,
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
            "currencyMultiplier" to 2.3
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${updateGooglePayConfigBaseError}: Value for 'currencyMultiplier' is not of type Integer",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun updateDigitalWalletConfiguration_sdkInitialized_walletNotEnabledInManifest_withValidGooglePayConfig_returnsInvalidGooglePaySetupError() = runBlocking {
        val args = mapOf(
            "countryCode" to "US",
            "companyLabel" to "Test Merchant",
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
                "${updateGooglePayConfigBaseError}: AndroidManifest missing com.google.android.gms.wallet.api.enabled entry",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("updateDigitalWalletConfiguration", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkNotInitialized_googlePayNotInitialized_returnsSdkUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
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
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNull_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "amount" to null,
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
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountMissing_returnsMissingParameterError() = runBlocking {
        val args = mapOf<String, Any>(
            // "amount" to 1.23 intentionally removed from args map
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
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNotDouble_returnsUnexpectedParameterTypeError() = runBlocking {
        val args = mapOf(
            "amount" to "1.23",
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
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountNegative_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "amount" to -1.23,
            "googlePayCheckoutStatus" to "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
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
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountPositive_returnsDigitalWalletUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to "FinalImmediatePurchase",
            "totalPriceLabel" to "Total",
            "validateLineItems" to true
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "DigitalWalletUninitialized",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_amountZero_returnsDigitalWalletUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 0.0,
            "googlePayCheckoutStatus" to "FinalImmediatePurchase",
            "totalPriceLabel" to "Total",
            "validateLineItems" to true
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "DigitalWalletUninitialized",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_withInvalidGooglePayCheckoutStatus_returnsInvalidParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to "invalidStatus",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "invalidStatus is not a valid parameter",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_googlePayCheckoutStatusNull_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to null,
            "validateLineItems" to true,
            "totalPriceLabel" to "Total"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'googlePayCheckoutStatus'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_googlePayCheckoutStatusMissing_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            // "googlePayCheckoutStatus" to  "FinalImmediatePurchase" intentionally removed from args map
            "validateLineItems" to true,
            "totalPriceLabel" to "Total"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'googlePayCheckoutStatus'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_validateLineItemsMissing_returnsMissingParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            // "validateLineItems" to true intentionally removed from args map
            "totalPriceLabel" to "Total"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'validateLineItems'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_validateLineItemsNotBoolean_returnsUnexpectedParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to "true",
            "totalPriceLabel" to "Total"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'validateLineItems' is not of type Boolean",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_totalPriceLabelNotString_returnsUnexpectedParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to 123
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'totalPriceLabel' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemsEmpty_returnsDigitalWalletUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to arrayListOf<HashMap<String, Any?>>()
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "DigitalWalletUninitialized",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemsNull_returnsDigitalWalletUninitializedError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to null
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "DigitalWalletUninitialized",
                "${getDigitalWalletPaymentMethodBaseError}: Google Pay has not been initialized",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemsNotList_returnsUnexpectedParameterError() = runBlocking {
        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to "notAList"
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItems' is not of type ArrayList",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemLabelEmpty_returnsInvalidParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "",
                "lineItemAmount" to 1.23,
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemLabel' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemLabelNull_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to null,
                "lineItemAmount" to 1.23,
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemLabelMissing_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                // "lineItemLabel" to null intentionally removed from lineItems map
                "lineItemAmount" to 1.23,
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemLabel'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemLabelNotString_returnsUnexpectedParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to 123,
                "lineItemAmount" to 1.23,
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemLabel' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemAmountNull_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to null,
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemAmount'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemAmountMissing_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                // "lineItemAmount" to null intentionally removed from lineItems map
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemAmount'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemAmountNotDouble_returnsUnexpectedParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to "1.23",
                "lineItemType" to "LineItem",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemAmount' is not of type Double",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemTypeNull_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to 1.23,
                "lineItemType" to null,
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemType'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemTypeEmpty_returnsInvalidParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to 1.23,
                "lineItemType" to "",
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "InvalidParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemType' cannot be empty",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemTypeMissing_returnsMissingParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to 1.23,
                // "lineItemType" to null intentionally removed from lineItems map
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "MissingParameter",
                "${getDigitalWalletPaymentMethodBaseError}: Missing parameter 'lineItemType'",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemTypeNotString_returnsUnexpectedParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to 1.23,
                "lineItemType" to 123,
                "lineItemStatus" to "Final"
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemType' is not of type String",
                null)
            assertFalse(plugin._googlePayReady)
            expectation.fulfill()
        }

        val call = MethodCall("createDigitalWalletPaymentMethod", args)
        plugin.onMethodCall(call, mockResult)
        expectation.wait()
    }

    @Test
    fun createDigitalWalletPaymentMethod_sdkInitialized_googlePayNotInitialized_lineItemStatusNotString_returnsUnexpectedParameterError() = runBlocking {
        val lineItems = arrayListOf(
            hashMapOf(
                "lineItemLabel" to "Test Item",
                "lineItemAmount" to 1.23,
                "lineItemType" to "LineItem",
                "lineItemStatus" to 123
            ),
        )

        val args = mapOf(
            "amount" to 1.23,
            "googlePayCheckoutStatus" to  "FinalImmediatePurchase",
            "validateLineItems" to true,
            "totalPriceLabel" to "Total",
            "lineItems" to lineItems,
        )

        waitForInitialization()

        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        val expectation = TestExpectation()

        plugin.onMethodCallFinished = MethodFinishedCallback {
            Mockito.verify(mockResult).error(
                "UnexpectedParameterType",
                "${getDigitalWalletPaymentMethodBaseError}: Value for 'lineItemStatus' is not of type String",
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


