// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCardFieldStateProtocolExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/7/24.
//

import XCTest
import OloPaySDK

final class OPCardFieldStateProtocolExtensionTests: XCTestCase {
    func testToDictionary_hasCorrectLength() {
        XCTAssertEqual(MockCardFieldState().toDictionary().count, 5)
    }
    
    func testToDictionary_hasCorrectKeys() {
        let dictionary = MockCardFieldState().toDictionary()
        
        XCTAssertNotNil(dictionary["isValid"])
        XCTAssertNotNil(dictionary["isEmpty"])
        XCTAssertNotNil(dictionary["wasEdited"])
        XCTAssertNotNil(dictionary["isFocused"])
        XCTAssertNotNil(dictionary["wasFocused"])
    }
    
    func testToDictionary_keysHaveCorrectValues() {
        let dictionary1 = MockCardFieldState(
            isValid: true,
            isEmpty: false,
            wasEdited: true,
            isFirstResponder: false,
            wasFirstResponder: true
        ).toDictionary()
        
        XCTAssertTrue((dictionary1["isValid"] as? Bool)!)
        XCTAssertFalse((dictionary1["isEmpty"] as? Bool)!)
        XCTAssertTrue((dictionary1["wasEdited"] as? Bool)!)
        XCTAssertFalse((dictionary1["isFocused"] as? Bool)!)
        XCTAssertTrue((dictionary1["wasFocused"] as? Bool)!)
        
        let dictionary2 = MockCardFieldState(
            isValid: false,
            isEmpty: true,
            wasEdited: false,
            isFirstResponder: true,
            wasFirstResponder: false
        ).toDictionary()
        
        XCTAssertFalse((dictionary2["isValid"] as? Bool)!)
        XCTAssertTrue((dictionary2["isEmpty"] as? Bool)!)
        XCTAssertFalse((dictionary2["wasEdited"] as? Bool)!)
        XCTAssertTrue((dictionary2["isFocused"] as? Bool)!)
        XCTAssertFalse((dictionary2["wasFocused"] as? Bool)!)
    }
}

public class MockCardFieldState : NSObject, OPCardFieldStateProtocol {
    public var isValid: Bool
    
    public var isEmpty: Bool
    
    public var wasEdited: Bool
    
    public var isFirstResponder: Bool
    
    public var wasFirstResponder: Bool
    
    override init() {
        isValid = true
        isEmpty = true
        wasEdited = true
        isFirstResponder = true
        wasFirstResponder = true
    }
    
    init(
        isValid: Bool,
        isEmpty: Bool,
        wasEdited: Bool,
        isFirstResponder: Bool,
        wasFirstResponder: Bool
    ) {
        self.isValid = isValid
        self.isEmpty = isEmpty
        self.wasEdited = wasEdited
        self.isFirstResponder = isFirstResponder
        self.wasFirstResponder = wasFirstResponder
    }
}
