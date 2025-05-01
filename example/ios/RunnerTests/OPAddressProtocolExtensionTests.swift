// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPAddressProtocolExtensionTests.swift
//  Runner
//
//  Created by Justin Anderson on 3/25/25.
//

import XCTest
import OloPaySDK

final class OPAddressProtocolExtensionTests: XCTestCase {
    func testToDictionary_hasCorrectLength() {
        XCTAssertEqual(MockBillingAddress().toDictionary().count, 8)
    }
    
    func testToDictionary_hasCorrectKeys() {
        let result = MockBillingAddress().toDictionary()
        
        XCTAssertNotNil(result["address1"])
        XCTAssertNotNil(result["address2"])
        XCTAssertNotNil(result["address3"])
        XCTAssertNotNil(result["locality"])
        XCTAssertNotNil(result["administrativeArea"])
        XCTAssertNotNil(result["sortingCode"])
        XCTAssertNotNil(result["postalCode"])
        XCTAssertNotNil(result["countryCode"])
    }
    
    func testToDictionary_keysHaveCorrectValues() {
        let result = MockBillingAddress().toDictionary()
        
        XCTAssertEqual(result["address1"], "123 ABC Street")
        XCTAssertEqual(result["address2"], "")
        XCTAssertEqual(result["address3"], "")
        XCTAssertEqual(result["locality"], "New York")
        XCTAssertEqual(result["administrativeArea"], "NY")
        XCTAssertEqual(result["sortingCode"], "")
        XCTAssertEqual(result["postalCode"], "10004")
        XCTAssertEqual(result["countryCode"], "US")
    }
}

public class MockBillingAddress: NSObject, OPAddressProtocol {
    public var street: String = "123 ABC Street"
    public var city: String = "New York"
    public var state: String = "NY"
    public var postalCode: String = "10004"
    public var countryCode: String = "US"
}
