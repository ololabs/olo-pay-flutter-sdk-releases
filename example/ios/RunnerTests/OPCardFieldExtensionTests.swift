// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import Flutter
import UIKit
import XCTest

@testable import olo_pay_sdk
import OloPaySDK

final class OPCardFieldExtensionTests: XCTestCase {
    func testFlutterBridgeValue_cardNumber_returnsNumberString() {
        XCTAssertEqual(OPCardField.number.flutterBridgeValue(), "CardNumber")
    }
    
    func testFlutterBridgeValue_expiration_returnsExpirationString() {
        XCTAssertEqual(OPCardField.expiration.flutterBridgeValue(), "Expiration")
    }
    
    func testFlutterBridgeValue_cvv_returnsCvvString() {
        XCTAssertEqual(OPCardField.cvv.flutterBridgeValue(), "Cvv")
    }
    
    func testFlutterBridgeValue_postalCode_returnsPostalCodeString() {
        XCTAssertEqual(OPCardField.postalCode.flutterBridgeValue(), "PostalCode")
    }
    
    func testFlutterBridgeValue_unknown_returnsEmptyString() {
        XCTAssertEqual(OPCardField.unknown.flutterBridgeValue(), "")
    }
}
