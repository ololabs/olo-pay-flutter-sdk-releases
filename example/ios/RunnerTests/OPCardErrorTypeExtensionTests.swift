// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCardErrorTypeExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/8/24.
//

import XCTest
import OloPaySDK
@testable import olo_pay_sdk

final class OPCardErrorTypeExtensionTests: XCTestCase {
    func testFlutterBridgeErrorType_invalidNumber_returnsFlutterInvalidNumberCode() {
        XCTAssertEqual(OPCardErrorType.invalidNumber.flutterBridgeErrorType(), "InvalidNumber")
    }
    
    func testFlutterBridgeErrorType_invalidExpMonth_returnsFlutterInvalidExpirationCode() {
        XCTAssertEqual(OPCardErrorType.invalidExpMonth.flutterBridgeErrorType(), "InvalidExpiration")
    }
    
    func testFlutterBridgeErrorType_invalidExpYear_returnsFlutterInvalidExpirationCode() {
        XCTAssertEqual(OPCardErrorType.invalidExpYear.flutterBridgeErrorType(), "InvalidExpiration")
    }
    
    func testFlutterBridgeErrorType_invalidCvv_returnsFlutterInvalidCvvCode() {
        XCTAssertEqual(OPCardErrorType.invalidCvv.flutterBridgeErrorType(), "InvalidCVV")
    }
    
    func testFlutterBridgeErrorType_invalidZip_returnsFlutterInvalidPostalCode() {
        XCTAssertEqual(OPCardErrorType.invalidZip.flutterBridgeErrorType(), "InvalidPostalCode")
    }
    
    func testFlutterBridgeErrorType_expiredCard_returnsFlutterExpiredCardCode() {
        XCTAssertEqual(OPCardErrorType.expiredCard.flutterBridgeErrorType(), "ExpiredCard")
    }
    
    func testFlutterBridgeErrorType_cardDeclined_returnsFlutterCardDeclinedCode() {
        XCTAssertEqual(OPCardErrorType.cardDeclined.flutterBridgeErrorType(), "CardDeclined")
    }
    
    func testFlutterBridgeErrorType_processingError_returnsFlutterProcessingErrorCode() {
        XCTAssertEqual(OPCardErrorType.processingError.flutterBridgeErrorType(), "ProcessingError")
    }
    
    func testFlutterBridgeErrorType_unknownCardError_returnsFlutterUnknownCardErrorCode() {
        XCTAssertEqual(OPCardErrorType.unknownCardError.flutterBridgeErrorType(), "UnknownCardError")
    }
}
