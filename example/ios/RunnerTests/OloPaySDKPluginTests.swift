// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OloPaySDKPluginTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/6/24.
//
import Flutter
import UIKit
import XCTest
@testable import olo_pay_sdk
@testable import OloPaySDK

final class OloPaySDKPluginTests: XCTestCase {
    // IMPORTANT: Using expectations makes debugging difficult due to the
    // waitForExpectationsCall() call. When debugging and stepping through
    // code, it may be necessary to set the timeout value to something
    // much larger to allow time to step through the code.
    //
    // NOTE: The value of 30 may seem excessive when not debugging, but
    // was reached through trial and error. Values less than this lead
    // to flaky test results in Github Actions
    let expectationTimeout: TimeInterval = 30
    
    var _plugin: OloPaySdkPlugin? = nil
    var plugin: OloPaySdkPlugin {
        get { _plugin! }
    }
    
    override func setUp() {
        _plugin = OloPaySdkPlugin()
    }
    
    override func tearDown() {
        OloPayAPI.sdkWrapperInfo = nil
        OPStorage.reset()
    }
    
    func testInitializeOloPay_withNilArgs_sdkInitialized_environmentDefaultsToProduction() {
        let call = FlutterMethodCall(methodName: "initialize", arguments: nil)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPEnvironment.production, OloPayAPI.environment)
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withoutEnvironmentArg_sdkInitialized_environmentDefaultsToProduction() {
        let arguments = ["Foo" : "Bar"]
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPEnvironment.production, OloPayAPI.environment)
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withFalseEnvironmentArg_sdkInitialized_environmentSetToTest() {
        let arguments = ["productionEnvironment" : false]
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPEnvironment.test, OloPayAPI.environment)
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withTrueEnvironmentArg_sdkInitialized_environmentSetToProduction() {
        let arguments = ["productionEnvironment" : true]
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPEnvironment.production, OloPayAPI.environment)
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_environmentArgNotBoolean_returnsUnexpectedParameterTypeError() {
        let arguments = ["productionEnvironment" : "true"]
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize OloPaySdk: Value for 'productionEnvironment' is not of type Bool"
            )
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_environmentArgNil_sdkInitialized_environmentSetToProduction() {
        let arguments = ["productionEnvironment" : nil] as [String : Any?]
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPEnvironment.production, OloPayAPI.environment)
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_missingMerchantId_returnsMissingParameterError() {
        let arguments = [
            "applePaySetup" : [
                "companyLabel" : ""
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Missing parameter 'merchantId'"
            )
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_emptyMerchantId_returnsInvalidParameterError() {
        let arguments = [
            "applePaySetup" : [
                "merchantId" : ""
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'merchantId' cannot be empty"
            )
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_merchantIdNotString_returnsUnexpectedParameterTypeError() {
        let arguments = [
            "applePaySetup" : [
                "merchantId" : true
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'merchantId' is not of type String"
            )
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_missingCompanyLabel_returnsMissingParameterError() {
        let arguments = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test"
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Missing parameter 'companyLabel'"
            )
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_emptyCompanyLabel_returnsInvalidParameterError() {
        let arguments = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : ""
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'companyLabel' cannot be empty"
            )
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_companyLabelNotString_returnsUnexpectedParameterTypeError() {
        let arguments = [
            "applePaySetup" : [
                "merchantId": "com.merchant.test",
                "companyLabel" : true
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'companyLabel' is not of type String"
            )
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeOloPay_withApplePayArgs_sdkInitialized_applePayArgsSet() {
        let arguments = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        
        let call = FlutterMethodCall(methodName: "initialize", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OPApplePayContext.companyLabel, "Foosburgers")
            XCTAssertEqual(OPApplePayContext.merchantId, "com.merchant.test")
            XCTAssertTrue(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testIsInitialized_sdkNotInitialized_returnsFalse() {
        let call = FlutterMethodCall(methodName: "isInitialized", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let initialized = self.assertBool(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertFalse(initialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testIsInitialized_sdkIsInitialized_returnsTrue() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "isInitialized", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let initialized = self.assertBool(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertTrue(initialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testIsDigitalWalletReady_sdkNotInitialized_returnsFalse() {
        let call = FlutterMethodCall(methodName: "isDigitalWalletReady", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let digitalWalletsReady = self.assertBool(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertFalse(digitalWalletsReady)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    //NOTE: We can't ensure that the test will return true for digital wallets being
    //      ready when the SDK is initialized, but we can verify it returns a boolean
    func testIsDigitalWalletReady_sdkInitialized_returnsBoolean() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let call = FlutterMethodCall(methodName: "isDigitalWalletReady", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            let _ = self.assertBool(result)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetFontNamesForAssets_withNilArgs_returnsMissingParameterError() {
        let call = FlutterMethodCall(methodName: "getFontNames", arguments: nil)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to get font names: Missing parameter fontAssetList"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetFontNamesForAssets_missingAssetListArg_returnsMissingParameterError() {
        let call = FlutterMethodCall(methodName: "getFontNames", arguments: [
            "foo" : "foo"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to get font names: Missing parameter 'fontAssetList'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetFontNamesForAssets_assetListNotArray_returnsUnexpectedParameterTypeError() {
        let call = FlutterMethodCall(methodName: "getFontNames", arguments: [
            "fontAssetList" : "foo"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to get font names: Value for 'fontAssetList' is not of type Array<Any>"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetFontNamesForAssets_assetListNotString_returnsInvalidParameterError() {
        let call = FlutterMethodCall(methodName: "getFontNames", arguments: [
            "fontAssetList" : [1, 2, 3]
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to load font asset. Asset is not a string or is empty"
            )
            
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetFontNamesForAssets_assetMissing_returnsAssetNotFoundError() {
        let call = FlutterMethodCall(methodName: "getFontNames", arguments: [
            "fontAssetList" : ["path/to/font.ttf"]
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to find font asset: path/to/font.ttf"
            )
            
            XCTAssertEqual(flutterError.code, "AssetNotFoundError")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkNotInitialized_returnsSdkUninitializedError() {
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Olo Pay SDK has not been initialized"
            )
            
            XCTAssertEqual(flutterError.code, "SdkUninitialized")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_withNilArgs_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        
        waitForInitialization(applePayArgs)
        
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: nil)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Missing parameter amount"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_amountNil_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        
        waitForInitialization(applePayArgs)
        
        let args = ["amount" : nil ] as [String : Any?]
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Missing parameter 'amount'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_amountMissing_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = ["Foo" : "Bar" ] as [String : Any?]
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Missing parameter 'amount'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_amountNotDouble_returnsUnexpectedParameterTypeError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = ["amount" : "Foo"]
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Value for 'amount' is not of type Double"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_amountNegative_returnsInvalidParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = ["amount" : -1.2]
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: amount cannot be negative"
            )
            
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_countryCodeNotString_returnsUnexpectedParameterTypeError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = [
            "amount" : 1.25,
            "countryCode" : true
        ] as [String : Any?]
        
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Value for 'countryCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testGetDigitalWalletPaymentMethod_sdkInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = [
            "amount" : 1.25,
            "countryCode" : "US",
            "currencyCode" : false
        ] as [String : Any?]
        
        let call = FlutterMethodCall(methodName: "createDigitalWalletPaymentMethod", arguments: args)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to create payment method: Value for 'currencyCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentMethodCreated_applePayResultNotCached_returnsError() {
        let error = plugin.applePaymentMethodCreated(
            MockApplePayContext(),
            didCreatePaymentMethod: MockPaymentMethod()
        )

        XCTAssertNotNil(error)
    }
    
    func testApplePaymentMethodCompleted_applePayResultCached_returnsNil() {
        let result: FlutterResult = { arg in }
        plugin._applePayResult = result
        
        let error = plugin.applePaymentMethodCreated(
            MockApplePayContext(),
            didCreatePaymentMethod: MockPaymentMethod()
        )
        
        XCTAssertNil(error)
    }
    
    func testApplePaymentCompleted_withErrorStatus_returnsErrorData() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            let result = data as? [String : String]
            XCTAssertEqual(result!["errorMessage"], "Test Error")
            XCTAssertEqual(result!["digitalWalletType"], "applePay")
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        let _ = plugin.applePaymentMethodCreated(
            MockApplePayContext(),
            didCreatePaymentMethod: MockPaymentMethod()
        )
        
        plugin.applePaymentCompleted(
            MockApplePayContext(),
            didCompleteWith: .error,
            error: OPError(errorType: .generalError, description: "Test Error")
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentCompleted_withSuccessStatus_withoutCachedPaymentMethod_returnsErrorData() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            let result = data as? [String : String]
            XCTAssertEqual(result!["errorMessage"], "Unexpected error: Payment method is nil")
            XCTAssertEqual(result!["digitalWalletType"], "applePay")
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        plugin.applePaymentCompleted(
            MockApplePayContext(),
            didCompleteWith: .success,
            error: nil
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentCompleted_withSuccessStatus_withCachedPaymentMethod_returnsPaymentMethodData() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            let result = data as? [String : Any]
            XCTAssertEqual(result!["id"] as? String, "testId")
            XCTAssertEqual(result!["last4"] as? String, "1234")
            XCTAssertEqual(result!["cardType"] as? String, "Visa")
            XCTAssertEqual(result!["expMonth"] as? NSNumber, 11)
            XCTAssertEqual(result!["expYear"] as? NSNumber, 23)
            XCTAssertEqual(result!["postalCode"] as? String, "55056")
            XCTAssertEqual(result!["countryCode"] as? String, "US")
            XCTAssertEqual(result!["isDigitalWallet"] as? Bool, true)
            XCTAssertEqual(result!["productionEnvironment"] as? Bool, false)
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        let _ = plugin.applePaymentMethodCreated(
            MockApplePayContext(),
            didCreatePaymentMethod: MockPaymentMethod()
        )
        
        plugin.applePaymentCompleted(
            MockApplePayContext(),
            didCompleteWith: .success,
            error: nil
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentCompleted_withUserCancelletationStatus_withoutCachedPaymentMethod_returnsNil() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            XCTAssertNil(data)
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        plugin.applePaymentCompleted(
            MockApplePayContext(),
            didCompleteWith: .userCancellation,
            error: nil
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentCompleted_withUserCancelletationStatus_withCachedPaymentMethod_returnsNil() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            XCTAssertNil(data)
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        
        let _ = plugin.applePaymentMethodCreated(
            MockApplePayContext(),
            didCreatePaymentMethod: MockPaymentMethod()
        )
        
        plugin.applePaymentCompleted(
            MockApplePayContext(),
            didCompleteWith: .userCancellation,
            error: nil
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_withNilArgs_wrapperInfoSetToDefaults_returnsNil() {
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: nil)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.version.description, "0.0.0")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.buildType.description, "internal")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_metadataContainsCorrectValues_wrapperInfoSetCorrectly_returnsNil() {
        let arguments = ["version": "3.2.1", "buildType": "public"] // non default values
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.version.description, "3.2.1")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.buildType.description, "public")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_emptyHybridVersion_setsDefaultHybridVersion_returnsNil() {
        let arguments = ["version": "", "buildType": "internal"]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.version.description, "0.0.0")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_nilHybridVersion_setsDefaultHybridVersion_returnsNil() {
        let arguments = ["version": nil, "buildType": "internal"]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.version.description, "0.0.0")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_missingHybridVersion_setsDefaultHybridVersion_returnsNil() {
        let arguments = ["buildType": "internal"]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.version.description, "0.0.0")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_hybridVersionNotString_returnsUnexpectedParameterTypeError() {
        let arguments = ["version": false, "buildType": "internal"] as [String : Any]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize metadata: Value for 'version' is not of type String"
            )
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_emptyHybridBuildType_setsDefaultHybridBuildType_returnsNil() {
        let arguments = ["version": "1.2.3", "buildType": ""]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.buildType.description, "internal")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_nilHybridBuildType_setsDefaultHybridBuildType_returnsNil() {
        let arguments = ["version": "1.2.3", "buildType": nil]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.buildType.description, "internal")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_missingHybridBuildType_setsDefaultHybridBuildType_returnsNil() {
        let arguments = ["version": "1.2.3"]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.buildType.description, "internal")
            XCTAssertEqual(OloPayAPI.sdkWrapperInfo?.platform.description, "flutter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeMetadata_hybridBuildTypeNotString_returnsUnexpectedParameterTypeError() {
        let arguments = ["version": "1.2.3", "buildType": false] as [String : Any]
        let call = FlutterMethodCall(methodName: "initializeMetadata", arguments: arguments)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize metadata: Value for 'buildType' is not of type String"
            )
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    private func assertError(_ result: Any?) -> FlutterError? {
        guard let flutterError = result as? FlutterError else {
            XCTFail("Result should be an error")
            return nil
        }
        
        return flutterError
    }
    
    private func assertBool(_ result: Any?) -> Bool? {
        guard let response = result as? Bool else {
            XCTFail("Result should be a boolean")
            return nil
        }
        
        return response
    }
    
    private func waitForInitialization(_ args: [String : Any] = [:]) {
        let initializeExpectation = expectation(description: "plugin not initialized")
        let call = FlutterMethodCall(methodName: "initialize", arguments: args)
        
        plugin.handle(call) { result in
            XCTAssertNil(result)
            initializeExpectation.fulfill()
        }
        
        wait(for: [initializeExpectation], timeout: expectationTimeout)
    }
    
    private class MockApplePayContext: NSObject, OPApplePayContextProtocol {
        var basketId: String?
        
        func presentApplePay(completion: OloPaySDK.OPVoidBlock?) throws {
            // Do nothing here
        }
        
        func presentApplePay(merchantId: String, companyLabel: String, completion: OloPaySDK.OPVoidBlock?) throws {
            // Do nothing here
        }
    }
}

