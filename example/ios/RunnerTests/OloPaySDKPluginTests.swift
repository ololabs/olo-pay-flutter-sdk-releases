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
import PassKit

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
    
    func testInitializeDigitalWallet_sdkNotInitialized_returnsSdkUninitializedError() {
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Olo Pay SDK has not been initialized"
            )
            
            XCTAssertEqual(flutterError.code, "SdkUninitialized")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_argsNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: nil)
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_merchantIdNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": nil
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_merchantIdMissing_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_merchantIdEmpty_returnsInvalidParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": ""
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_merchantIdNotString_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": true
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_companyLabelNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": nil
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_companyLabelMissing_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            // "companyLabel" intentionally missing
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_companyLabelEmpty_returnsInvalidParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": ""
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_companyLabelNotString() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": 1.23
        ])
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
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_currencyCodeUnsupported_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": "Test Company",
            "currencyCode": "MXN"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: MXN is not supported"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": "Test Company",
            "currencyCode": false
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'currencyCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_countryCodeNotString() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": false
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'countryCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_fullBillingAddressRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'fullBillingAddressRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_emailRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": "Foobar"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'emailRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_phoneNumberRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": false,
            "phoneNumberRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'phoneNumberRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testInitializeDigitalWallet_sdkInitialized_fullNameRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "initializeDigitalWallet", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": false,
            "phoneNumberRequired": false,
            "fullNameRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to initialize Apple Pay: Value for 'fullNameRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }

    func testUpdateDigitalWalletConfiguration_sdkNotInitialized_returnsSdkUninitializedError() {
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Olo Pay SDK has not been initialized"
            )
            
            XCTAssertEqual(flutterError.code, "SdkUninitialized")
            XCTAssertFalse(self.plugin.sdkInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_argsNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: nil)
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Missing parameter 'merchantId'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_merchantIdNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": nil
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Missing parameter 'merchantId'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_merchantIdMissing_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Missing parameter 'merchantId'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_merchantIdEmpty_returnsInvalidParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": ""
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'merchantId' cannot be empty"
            )
            
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_merchantIdNotString() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": true
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'merchantId' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_companyLabelNil_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": nil
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Missing parameter 'companyLabel'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_companyLabelMissing_returnsMissingParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            // "companyLabel" intentionally missing
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Missing parameter 'companyLabel'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_companyLabelEmpty_returnsInvalidParameterError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": ""
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'companyLabel' cannot be empty"
            )
            
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_companyLabelNotString() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'companyLabel' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_currencyCodeUnsupported_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": "Test Company",
            "currencyCode": "MXN"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: MXN is not supported"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_currencyCodeNotString_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "companyLabel": "Test Company",
            "currencyCode": false
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'currencyCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_countryCodeNotString() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": false
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'countryCode' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_fullBillingAddressRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'fullBillingAddressRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_emailRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": "Foobar"
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'emailRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_phoneNumberRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": false,
            "phoneNumberRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'phoneNumberRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testUpdateDigitalWalletConfiguration_sdkInitialized_fullNameRequiredNotBoolean_returnsUnexpectedParameterTypeError() {
        waitForInitialization()
        
        let call = FlutterMethodCall(methodName: "updateDigitalWalletConfiguration", arguments: [
            "merchantId": "merchant.com.test",
            "currencyCode": "USD",
            "companyLabel": "Test Company",
            "countryCode": "US",
            "fullBillingAddressRequired": true,
            "emailRequired": false,
            "phoneNumberRequired": false,
            "fullNameRequired": 1.23
        ])
        let methodCallExpectation = expectation(description: "result must be called")
        
        plugin.handle(call) { result in
            guard let flutterError = self.assertError(result) else {
                methodCallExpectation.fulfill()
                return
            }
            
            XCTAssertEqual(
                flutterError.message,
                "Unable to update Apple Pay configuration: Value for 'fullNameRequired' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            XCTAssertFalse(self.plugin.applePayInitialized)
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
    
    func testCreateDigitalWalletPaymentMethod_sdkNotInitialized_returnsSdkUninitializedError() {
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_withNilArgs_returnsMissingParameterError() {
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_amountNil_returnsMissingParameterError() {
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_amountMissing_returnsMissingParameterError() {
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_amountNotDouble_returnsUnexpectedParameterTypeError() {
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_amountNegative_returnsInvalidParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = ["amount" : -1.2, "validateLineItems": true, "lineItems": []] as [String : Any?]
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
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_validateLineItemsMissing_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = [
            "amount" : 1.00,
            // "validateLineItems": true, intentionally missing
            "lineItems": nil
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
                "Unable to create payment method: Missing parameter 'validateLineItems'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_validateLineItemsNotBoolean_returnsUnexpectedParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": "true",
            "lineItems": nil
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
                "Unable to create payment method: Value for 'validateLineItems' is not of type Bool"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemsNotList_returnsUnexpectedParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": "List"
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
                "Unable to create payment method: Value for 'lineItems' is not of type Optional<Array<Dictionary<String, Optional<Any>>>>"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemLabelEmpty_returnsInvalidParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems = [
            [
                "lineItemLabel": "",
                "lineItemAmount": 1.23,
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Value for 'lineItemLabel' cannot be empty"
            )
            
            XCTAssertEqual(flutterError.code, "InvalidParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemLabelNSNull_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": NSNull(),
                "lineItemAmount": 1.23,
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Missing parameter 'lineItemLabel'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemLabelMissing_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                // "lineItemLabel": "Test", intentionally removed
                "lineItemAmount": 1.23,
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Missing parameter 'lineItemLabel'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemLabelNotString_returnsUnexpectedParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": 1.23,
                "lineItemAmount": 1.23,
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Value for 'lineItemLabel' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemAmountNSNull_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": "Test",
                "lineItemAmount": NSNull(),
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Missing parameter 'lineItemAmount'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemAmountMissing_returnsMissingParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": "Test",
                // "lineItemAmount": 1.23, intentionally removed
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Missing parameter 'lineItemAmount'"
            )
            
            XCTAssertEqual(flutterError.code, "MissingParameter")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemAmountNotDouble_returnsUnexpectedParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": "Test",
                "lineItemAmount": "1.23",
                "lineItemStatus": "Final"
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Value for 'lineItemAmount' is not of type Double"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testCreateDigitalWalletPaymentMethod_sdkInitialized_lineItemStatusNotString_returnsUnexpectedParameterError() {
        let applePayArgs = [
            "applePaySetup" : [
                "merchantId" : "com.merchant.test",
                "companyLabel" : "Foosburgers"
            ]
        ]
        waitForInitialization(applePayArgs)
        
        let lineItems: [Dictionary<String, Any?>] = [
            [
                "lineItemLabel": "Test",
                "lineItemAmount": 1.23,
                "lineItemStatus": true
            ]
        ]
        
        let args = [
            "amount" : 1.00,
            "validateLineItems": true,
            "lineItems": lineItems
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
                "Unable to create payment method: Value for 'lineItemStatus' is not of type String"
            )
            
            XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
            methodCallExpectation.fulfill()
        }
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentMethodCreated_applePayResultNotCached_returnsError() {
        let error = plugin.paymentMethodCreated(
            from: MockApplePayLauncher(),
            with: MockPaymentMethod()
        )

        XCTAssertNotNil(error)
    }
    
    func testApplePaymentMethodCompleted_applePayResultCached_returnsNil() {
        let result: FlutterResult = { arg in }
        plugin._applePayResult = result
        
        let error = plugin.paymentMethodCreated(
            from: MockApplePayLauncher(),
            with: MockPaymentMethod()
        )
        
        XCTAssertNil(error)
    }
    
    func testApplePaymentCompleted_withErrorStatus_returnsErrorData() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            let result = data as? [String : String]
            XCTAssertEqual(result!["errorMessage"], "Test Error")
            XCTAssertEqual(result!["digitalWalletErrorCode"], "generalError")
            XCTAssertEqual(result!["digitalWalletType"], "applePay")
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        let _ = plugin.paymentMethodCreated(
            from: MockApplePayLauncher(),
            with: MockPaymentMethod()
        )
        
        plugin.applePayDismissed(
            from: MockApplePayLauncher(),
            with: .error,
            error: OPError(errorType: .generalError, description: "Test Error")
        )
        
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
    }
    
    func testApplePaymentCompleted_withSuccessStatus_withoutCachedPaymentMethod_returnsErrorData() {
        let methodCallExpectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            let result = data as? [String : String]
            XCTAssertEqual(result!["errorMessage"], "Unexpected error: Payment method is nil")
            XCTAssertEqual(result!["digitalWalletErrorCode"], "generalError")
            XCTAssertEqual(result!["digitalWalletType"], "applePay")
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        plugin.applePayDismissed(
            from: MockApplePayLauncher(),
            with: .success,
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
            XCTAssertEqual(result!["email"] as? String, "user@example.com")
            XCTAssertEqual(result!["digitalWalletCardDescription"] as? String, "Apple Pay Description")
            XCTAssertEqual(result!["fullName"] as? String, "Ron Idaho")
            XCTAssertEqual(result!["phoneNumber"] as? String, "555-555-5555")
            
            let billingAddress = result!["billingAddress"] as? [String : Any]
            XCTAssertNotNil(billingAddress)
            XCTAssertEqual(billingAddress!["address1"] as? String, "123 ABC Street")
            XCTAssertEqual(billingAddress!["locality"] as? String, "New York")
            XCTAssertEqual(billingAddress!["administrativeArea"] as? String, "NY")
            XCTAssertEqual(billingAddress!["postalCode"] as? String, "10004")
            XCTAssertEqual(billingAddress!["countryCode"] as? String, "US")
            
            methodCallExpectation.fulfill()
        }
        
        plugin._applePayResult = result
        let _ = plugin.paymentMethodCreated(
            from: MockApplePayLauncher(),
            with: MockPaymentMethod()
        )
        
        plugin.applePayDismissed(
            from: MockApplePayLauncher(),
            with: .success,
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
        plugin.applePayDismissed(
            from: MockApplePayLauncher(),
            with: .userCancellation,
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
        
        let _ = plugin.paymentMethodCreated(
            from: MockApplePayLauncher(),
            with: MockPaymentMethod()
        )
        
        plugin.applePayDismissed(
            from: MockApplePayLauncher(),
            with: .userCancellation,
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
    
    private class MockApplePayLauncher: NSObject, OPApplePayLauncherProtocol {
        var configuration: OloPaySDK.OPApplePayConfiguration?
        
        var delegate: (any OloPaySDK.OPApplePayLauncherDelegate)?
        
        func present(for amount: NSDecimalNumber, completion: OloPaySDK.OPVoidBlock?) throws {
            // Do nothing here
        }
        
        func present(for amount: NSDecimalNumber, with lineItems: [PKPaymentSummaryItem]?, validateLineItems: Bool, completion: OloPaySDK.OPVoidBlock?) throws {
            // Do nothing here
        }
        
        static func canMakePayments() -> Bool {
            return false
        }
        
        var basketId: String?
    }
}

