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
        XCTAssertEqual(MockPaymentMethod().toDictionary().count, 14)
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
        XCTAssertNotNil(result["email"])
        XCTAssertNotNil(result["digitalWalletCardDescription"])
        XCTAssertNotNil(result["fullName"])
        XCTAssertNotNil(result["phoneNumber"])
        XCTAssertNotNil(result["billingAddress"])
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
        XCTAssertEqual(result["email"] as? String, "user@example.com")
        XCTAssertEqual(result["digitalWalletCardDescription"] as? String, "Apple Pay Description")
        XCTAssertEqual(result["fullName"] as? String, "Ron Idaho")
        XCTAssertEqual(result["phoneNumber"] as? String, "555-555-5555")
        XCTAssertNotNil(result["billingAddress"] as? [String : Any])
    }
}

public class MockPaymentMethod: NSObject, OPPaymentMethodProtocol {
    public var id: String = "testId"
    public var last4: String = "1234"
    public var cardType: OPCardBrand = OPCardBrand.visa
    public var expirationMonth: NSNumber? = 11
    public var expirationYear: NSNumber? = 23
    public var postalCode: String = "55056"
    public var countryCode: String = "US"
    public var isApplePay: Bool = true
    public var environment: OPEnvironment = OPEnvironment.test
    public var applePayCardDescription: String = "Apple Pay Description"
    public var billingAddress: any OloPaySDK.OPAddressProtocol = MockBillingAddress()
    public var email: String = "user@example.com"
    public var phoneNumber: String = "555-555-5555"
    public var fullName: String = "Ron Idaho"
    public var fullPhoneticName: String = ""
}

