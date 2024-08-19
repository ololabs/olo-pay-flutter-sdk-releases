// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  DictionaryExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/7/24.
//

import XCTest

@testable import olo_pay_sdk
import OloPaySDK

final class DictionaryExtensionTests: XCTestCase {
    func testGet_keyExists_valueIsCorrectType_returnsValue() {
        let dictionary = [ "Foo" : "Bar" ]
        let value: String? = dictionary.get("Foo")
        XCTAssertEqual(value, "Bar")
    }

    func testGet_keyExists_valueNotCorrectType_returnsNil() {
        let dictionary = [ "Foo" : 2 ]
        let value: String? = dictionary.get("Foo")
        XCTAssertNil(value)
    }

    func testGet_keyMissing_returnsNil() {
        let dictionary = [ "Foo" : "Bar" ]
        let value: String? = dictionary.get("Bar")
        XCTAssertNil(value)
    }
    
    func testGetOrThrow_keyMissing_throwsMissingKeyError() {
        var correctErrorThrown = false
        
        let dictionary = [ "Foo" : 2.3 ]
        do {
            let _: Double = try dictionary.getOrThrow("Bar")
            XCTFail("Error not thrown")
        } catch OloError.MissingKeyError {
            correctErrorThrown = true
        } catch {
            correctErrorThrown = false
        }
        
        XCTAssertTrue(correctErrorThrown)
    }
    
    // NSNull is how Flutter represents null values sent across the bridge
    func testGetOrThrow_keyExists_valueIsNSNull_throwsNullValueError() {
        var correctErrorThrown = false
        
        let dictionary = [ "Foo" : NSNull() ] as [String : Any?]
        do {
            let _: String = try dictionary.getOrThrow("Foo")
            XCTFail("Error not thrown")
        } catch OloError.NullValueError {
            correctErrorThrown = true
        } catch {
            correctErrorThrown = false
        }
        
        XCTAssertTrue(correctErrorThrown)
    }
    
    func testGetOrThrow_keyExists_valueIsIncorrectType_throwsUnexpectedTypeError() {
        var correctErrorThrown = false
        
        let dictionary = [ "Foo" : 123 ] as [String : Any?]
        do {
            let _: String = try dictionary.getOrThrow("Foo")
            XCTFail("Error not thrown")
        } catch OloError.UnexpectedTypeError {
            correctErrorThrown = true
        } catch {
            correctErrorThrown = false
        }
        
        XCTAssertTrue(correctErrorThrown)
    }
    
    func testGetOrThrow_keyExists_valueIsCorrectType_returnsArgValue() {
        let dictionary = [ "Foo" : 123 ] as [String : Any?]
        do {
            let value: Int = try dictionary.getOrThrow("Foo")
            XCTAssertEqual(123, value)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }
    
    func testGetOrThrow_withDefaultValue_keyMissing_returnsDefaultValue() {
        let dictionary = [ "Foo" : 2.3 ]
        do {
            let value: Double = try dictionary.getOrThrow("Bar", defaultValue: 12.3)
            XCTAssertEqual(12.3, value)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }
    
    // NSNull is how Flutter represents null values sent across the bridge
    func testGetOrThrow_withDefaultValue_keyExists_valueIsNSNull_returnsDefaultValue() {
        let dictionary = [ "Foo" : NSNull() ] as [String : Any?]
        do {
            let value: String = try dictionary.getOrThrow("Foo", defaultValue: "Bar")
            XCTAssertEqual("Bar", value)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }
    
    func testGetOrThrow_withDefaultValue_keyExists_valueIsIncorrectType_throwsUnexpectedTypeError() {
        var correctErrorThrown = false
        
        let dictionary = [ "Foo" : 123 ] as [String : Any?]
        do {
            let _: String = try dictionary.getOrThrow("Foo", defaultValue: "Bar")
            XCTFail("Error not thrown")
        } catch OloError.UnexpectedTypeError {
            correctErrorThrown = true
        } catch {
            correctErrorThrown = false
        }
        
        XCTAssertTrue(correctErrorThrown)
    }
    
    func testGetOrThrow_withDefaultValue_keyExists_valueIsCorrectType_returnsArgValue() {
        let dictionary = [ "Foo" : 123 ] as [String : Any?]
        do {
            let value: Int = try dictionary.getOrThrow("Foo", defaultValue: 2)
            XCTAssertEqual(123, value)
        } catch {
            XCTFail("Error should not be thrown")
        }
    }
    
    func testGetDictionary_keyExists_valueIsDictionary_returnsValue() {
        let dictionary = [ "Foo" :
            [ "Bar" : 1 ]
        ]
        
        let value = dictionary.getDictionary("Foo")
        XCTAssertNotNil(value)
        XCTAssertEqual((value!["Bar"] as! Int), 1)
    }

    func testGetDictionary_keyExists_valueNotDictionary_returnsNil() {
        let dictionary = [ "Foo" : 2 ]
        XCTAssertNil(dictionary.getDictionary("Foo"))
    }

    func testGetDictionary_keyMissing_returnsNil() {
        let dictionary = [ "Foo" : "Bar" ]
        XCTAssertNil(dictionary.getDictionary("Bar"))
    }
    
    func testGetArray_keyExists_valueIsArray_returnsValue() {
        let dictionary = [ "Foo" : 
            [ 1, 2, 3 ]
        ]
        
        let value = dictionary.getArray("Foo")
        XCTAssertNotNil(value)
        XCTAssertEqual(value![0] as! Int, 1)
    }
    
    func testGetArray_keyExists_valueNotArray_returnsNil() {
        let dictionary = [ "Foo" : "Bar" ]
        XCTAssertNil(dictionary.getArray("Bar"))
    }
    
    func testGetArray_keyMissing_returnsNil() {
        let dictionary = [ "Foo2" :
            [ 1, 2, 3 ]
        ]
        
        XCTAssertNil(dictionary.getArray("Foo"))
    }
    
    func testFieldStateDictionary_ToDictionary_hasCorrectLength() {
        XCTAssertEqual(getFieldStatesDictionary().toDictionary().count, 4)
    }
    
    func testFieldStateDictionary_ToDictionary_hasCorrectKeys() {
        let dictionary = getFieldStatesDictionary().toDictionary()
        
        XCTAssertNotNil(dictionary["CardNumber"])
        XCTAssertNotNil(dictionary["Expiration"])
        XCTAssertNotNil(dictionary["Cvv"])
        XCTAssertNotNil(dictionary["PostalCode"])
    }
    
    func getFieldStatesDictionary() -> [OPCardField : OPCardFieldStateProtocol] {
        return [
            OPCardField.number : MockCardFieldState(),
            OPCardField.expiration : MockCardFieldState(),
            OPCardField.cvv : MockCardFieldState(),
            OPCardField.postalCode: MockCardFieldState()
        ]
    }
}
