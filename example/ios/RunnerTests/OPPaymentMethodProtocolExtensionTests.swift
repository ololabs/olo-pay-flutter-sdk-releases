// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPPaymentMethodProtocolExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/7/24.
//

import XCTest
import OloPaySDK

final class OPPaymentMethodProtocolExtensionTests: XCTestCase {
    func testToDictionary_hasCorrectLength() {
        XCTAssertEqual(MockPaymentMethod().toDictionary().count, 9)
    }
    
    func testToDictionary_hasCorrectKeys() {
        let result = MockPaymentMethod().toDictionary()
        
        XCTAssertNotNil(result["id"])
        XCTAssertNotNil(result["last4"])
        XCTAssertNotNil(result["cardType"])
        XCTAssertNotNil(result["expMonth"])
        XCTAssertNotNil(result["expYear"])
        XCTAssertNotNil(result["postalCode"])
        XCTAssertNotNil(result["countryCode"])
        XCTAssertNotNil(result["isDigitalWallet"])
        XCTAssertNotNil(result["productionEnvironment"])
    }
    
    func testToDictionary_keysHaveCorrectValues() {
        let result = MockPaymentMethod().toDictionary()
        
        XCTAssertEqual(result["id"] as? String, "testId")
        XCTAssertEqual(result["last4"] as? String, "1234")
        XCTAssertEqual(result["cardType"] as? String, "Visa")
        XCTAssertEqual(result["expMonth"] as? NSNumber, 11)
        XCTAssertEqual(result["expYear"] as? NSNumber, 23)
        XCTAssertEqual(result["postalCode"] as? String, "55056")
        XCTAssertEqual(result["countryCode"] as? String, "US")
        XCTAssertEqual(result["isDigitalWallet"] as? Bool, true)
        XCTAssertEqual(result["productionEnvironment"] as? Bool, false)
    }
}

public class MockPaymentMethod: NSObject, OPPaymentMethodProtocol {
    public var id: String = "testId"
    public var last4: String? = "1234"
    public var cardType: OPCardBrand = OPCardBrand.visa
    public var expirationMonth: NSNumber? = 11
    public var expirationYear: NSNumber? = 23
    public var postalCode: String? = "55056"
    public var isApplePay: Bool = true
    public var country: String? = "US"
    public var environment: OPEnvironment = OPEnvironment.test
}
