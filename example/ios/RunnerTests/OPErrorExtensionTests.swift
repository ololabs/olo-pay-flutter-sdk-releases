// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPErrorExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/8/24.
//

import XCTest
@testable import olo_pay_sdk
import OloPaySDK

final class OPErrorExtensionTests: XCTestCase {
    func testFlutterBridgeErrorType_connectionError_returnsFlutterConnectionErrorCode() {
        let error = OPError(errorType: .connectionError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "ConnectionError")
    }
    
    func testFlutterBridgeErrorType_invalidRequestError_returnsFlutterInvalidRequestCode() {
        let error = OPError(errorType: .invalidRequestError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "InvalidRequest")
    }
    
    func testFlutterBridgeErrorType_apiError_returnsFlutterApiErrorCode() {
        let error = OPError(errorType: .apiError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "ApiError")
    }
    
    func testFlutterBridgeErrorType_cancellationError_returnsFlutterCancellationErrorCode() {
        let error = OPError(errorType: .cancellationError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "CancellationError")
    }
    
    func testFlutterBridgeErrorType_authenticationError_returnsFlutterAuthenticationErrorCode() {
        let error = OPError(errorType: .authenticationError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "AuthenticationError")
    }
    
    func testFlutterBridgeErrorType_generalError_returnsFlutterGeneralErrorCode() {
        let error = OPError(errorType: .generalError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "generalError")
    }
    
    func testFlutterBridgeErrorType_applePayContextError_returnsFlutterGeneralErrorCode() {
        let error = OPError(errorType: .applePayContextError, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "generalError")
    }
    
    // NOTE: We are only testing one card error type to ensure card error logic is processed correctly
    //       with OPError.flutterBridgeErrorType(). The remaining card error logic is tested separately
    //       in OPCardErrorTypeExtensionTests. If we were to add tests here for each kind of card type
    //       error we'd essentially be testing the same logic twice
    func testFlutterBridgeErrorType_cardError_invalidNumber_returnsFlutterInvalidNumberErrorCode() {
        let error = OPError(cardErrorType: .invalidNumber, description: "")
        XCTAssertEqual(error.flutterBridgeErrorType(), "InvalidNumber")
    }
}
