//
//  FlutterDictionaryExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 4/29/24.
//

import XCTest
import Flutter
@testable import olo_pay_sdk

final class FlutterDictionaryExtensionTests: XCTestCase {
    // IMPORTANT: Using expectations makes debugging difficult due to the
    // waitForExpectationsCall() call. When debugging and stepping through
    // code, it may be necessary to set the timeout value to something
    // much larger to allow time to step through the code.
    //
    // NOTE: The value of 30 may seem excessive when not debugging, but
    // was reached through trial and error. Values less than this lead
    // to flaky test results in Github Actions
    let expectationTimeout: TimeInterval = 30
    
    // MARK: Non-Null Dictionary Extension Tests
    func testGetOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyError() {
        let arguments = ["foo": "1.2.3"]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "bar",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Missing parameter 'bar'"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.MissingKeyError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetOrErrorResult_argValueIsNSNull_returnsMissingParameter_throwsNullValueError() {
        let arguments = ["foo": NSNull()]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "foo",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Missing parameter 'foo'"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetOrErrorResult_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        let arguments = ["foo": true]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "foo",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Value for 'foo' is not of type String"
                )
                XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
                methodCallExpectation.fulfill()
            }
        } catch OloError.UnexpectedTypeError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetOrErrorResult_argValueIsCorrectType_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getOrErrorResult(
                for: "foo",
                baseError: "Test"
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        let arguments = ["foo": "1.2.3"]
        
        do {
            let strValue: String = try arguments.getOrErrorResult(
                for: "bar",
                withDefault: "default",
                baseError: "Test"
            ) { result in
                XCTFail("Result should not be called")
            }
            
            XCTAssertEqual("default", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetOrErrorResult_withDefaultValue_argValueIsNSNull_returnsDefaultValue() {
        let arguments = ["foo": NSNull()]
        
        do {
            let strValue: String = try arguments.getOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test"
            ) { result in
                XCTFail("Result should not be called")
            }
            
            XCTAssertEqual("default", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetOrErrorResult_withDefaultValue_argValueIncorrectType_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        let arguments = ["foo": true]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Value for 'foo' is not of type String"
                )
                XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
                methodCallExpectation.fulfill()
            }
        } catch OloError.UnexpectedTypeError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetOrErrorResult_withDefaultValue_argValueIsCorrectType_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test"
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_argsMissingKey_returnsMissingParameter_throwsMissingKeyError() {
        let arguments = ["foo": "1.2.3"]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "bar",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Missing parameter 'bar'"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.MissingKeyError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_argValueIsNSNull_returnsMissingParameter_throwsNullValueError() {
        let arguments = ["foo": NSNull()]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Missing parameter 'foo'"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        let arguments = ["foo": true]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Value for 'foo' is not of type String"
                )
                XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
                methodCallExpectation.fulfill()
            }
        } catch OloError.UnexpectedTypeError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_emptyValueNotAccepted_argValueIsEmpty_returnsInvalidParameter_throwsEmptyValueError() {
        let arguments = ["foo": ""]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: false
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Value for 'foo' cannot be empty"
                )
                XCTAssertEqual(flutterError.code, "InvalidParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.EmptyValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: false
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_emptyValueAccepted_argValueIsEmpty_returnsEmptyString() {
        let arguments = ["foo": ""]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_emptyValueAccepted_argValueNotEmpty_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_argsMissingKey_returnsDefaultValue() {
        let arguments = ["foo": "1.2.3"]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "bar",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            
            XCTAssertEqual("default", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_argValueIsNSNull_returnsDefaultValue() {
        let arguments = ["foo": NSNull()]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            
            XCTAssertEqual("default", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_argValueNotString_returnsUnexpectedParameterType_throwsUnexpectedTypeError() {
        let arguments = ["foo": true]
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Value for 'foo' is not of type String"
                )
                XCTAssertEqual(flutterError.code, "UnexpectedParameterType")
                methodCallExpectation.fulfill()
            }
        } catch OloError.UnexpectedTypeError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueEmpty_returnsDefaultValue() {
        let arguments = ["foo": ""]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: false
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("default", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_emptyValueNotAccepted_argValueNotEmpty_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: false
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_emptyValueAccepted_argValueEmpty_returnsEmptyValue() {
        let arguments = ["foo": ""]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    func testGetStringOrErrorResult_withDefaultValue_emptyValueAccepted_argValueNotEmpty_returnsArgValue() {
        let arguments = ["foo": "bar"]
        
        do {
            let strValue: String = try arguments.getStringOrErrorResult(
                for: "foo",
                withDefault: "default",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                XCTFail("Result should not be called")
            }
            XCTAssertEqual("bar", strValue)
        } catch {
            XCTFail("Exception should not be thrown")
        }
    }
    
    private func assertError(_ result: Any?) -> FlutterError? {
        guard let flutterError = result as? FlutterError else {
            XCTFail("Result should be an error")
            return nil
        }
        
        return flutterError
    }
    
    // MARK: Nullable Dictionary Extension Tests
    func testGetOrErrorResult_nullDictionary_throwsNullValueError() {
        let arguments: Dictionary<String, Any>? = nil
        let methodCallExpectation = expectation(description: "result must be called")
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "bar",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Arguments dictionary is nil"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetOrErrorResult_withDefaultValue_nullDictionary_throwsNullValueError() {
        let arguments: Dictionary<String, Any>? = nil
        let methodCallExpectation = expectation(description: "result must be called")
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getOrErrorResult(
                for: "bar",
                withDefault: "foo",
                baseError: "Test"
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Arguments dictionary is nil"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_nullDictionary_throwsNullValueError() {
        let arguments: Dictionary<String, Any>? = nil
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "bar",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Arguments dictionary is nil"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
    
    func testGetStringOrErrorResult_withDefaultValue_nullDictionary_throwsNullValueError() {
        let arguments: Dictionary<String, Any>? = nil
        let methodCallExpectation = expectation(description: "result must be called")
        
        var correctExceptionThrown = false
        
        do {
            let _: String = try arguments.getStringOrErrorResult(
                for: "bar",
                withDefault: "foo",
                baseError: "Test",
                acceptEmptyValue: true
            ) { result in
                guard let flutterError = self.assertError(result) else {
                    methodCallExpectation.fulfill()
                    return
                }
                
                XCTAssertEqual(
                    flutterError.message,
                    "Test: Arguments dictionary is nil"
                )
                XCTAssertEqual(flutterError.code, "MissingParameter")
                methodCallExpectation.fulfill()
            }
        } catch OloError.NullValueError {
            correctExceptionThrown = true
        } catch {
            correctExceptionThrown = false
        }
                
        wait(for: [methodCallExpectation], timeout: expectationTimeout)
        XCTAssertTrue(correctExceptionThrown)
    }
}
