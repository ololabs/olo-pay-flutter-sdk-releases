// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ErrorHandlingHelpersTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 2/8/24.
//

import XCTest
@testable import olo_pay_sdk
import OloPaySDK
import Flutter

final class ErrorHandlingHelpersTests: XCTestCase {
    // IMPORTANT: Using expectations makes debugging difficult due to the
    // waitForExpectationsCall() call. When debugging, consider setting
    // the timeout value to something extraordinarily large to allow you
    // time to step through the code.
    let expectationTimeout: TimeInterval = 2
    
    func testGetErrorMessage_errorHaslocalizedDescription_localizedDescriptionReturned() {
        let error = OPError(errorType: .generalError, description: "Foo bar")
        XCTAssertEqual(getErrorMessage(error: error, defaultMessage: "Hi"), "Foo bar")
    }
    
    func testGetErrorMessage_errorMissingLocalizedDescription_defaultMessageReturned() {
        let error = OPError(errorType: .generalError, description: "")
        XCTAssertEqual(getErrorMessage(error: error, defaultMessage: "Hi"), "Hi")
    }
    
    func testRejectError_withOPError_flutterResultCalled_withErrorMessage() {
        let expectation = expectation(description: "result must be called")
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "generalError")
            XCTAssertEqual(flutterError.message, "Test error message")
            expectation.fulfill()
        }
        
        let error = OPError(errorType: .generalError, description: "Test error message")
        rejectError(error: error, result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    func testRejectError_withOPError_flutterResultCalled_withDefaultMessage() {
        let expectation = expectation(description: "result must be called")
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "ApiError")
            XCTAssertEqual(flutterError.message, "Unexpected error occurred")
            expectation.fulfill()
        }
        
        let error = OPError(errorType: .apiError, description: "")
        rejectError(error: error, result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    func testRejectError_withOPErrorAsSwiftError_flutterResultCalled_withErrorMessage() {
        let expectation = expectation(description: "result must be called")
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "generalError")
            XCTAssertEqual(flutterError.message, "Test error message")
            expectation.fulfill()
        }
        
        let error: Error = OPError(errorType: .generalError, description: "Test error message")
        rejectError(error: error, result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    func testRejectError_withOPErrorAsSwiftError_flutterResultCalled_withDefaultMessage() {
        let expectation = expectation(description: "result must be called")
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "ApiError")
            XCTAssertEqual(flutterError.message, "Unexpected error occurred")
            expectation.fulfill()
        }
        
        let error: Error = OPError(errorType: .apiError, description: "")
        rejectError(error: error, result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    func testRejectError_withSwiftError_flutterResultCalled_withErrorMessage() {
        let expectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "generalError")
            XCTAssertEqual(flutterError.message, "Test error message")
            expectation.fulfill()
        }
        
        rejectError(error: MockError(message: "Test error message"), result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    func testRejectError_withSwiftError_flutterResultCalled_withDefaultErrorMessage() {
        let expectation = expectation(description: "result must be called")
        
        let result: FlutterResult = { data in
            guard let flutterError = self.assertError(data) else {
                expectation.fulfill()
                return
            }
            
            XCTAssertEqual(flutterError.code, "generalError")
            XCTAssertEqual(flutterError.message, "Unexpected error occurred")
            expectation.fulfill()
        }
        
        rejectError(error: MockError(message: ""), result: result)
        waitForExpectations(timeout: expectationTimeout)
    }
    
    private func assertError(_ result: Any?) -> FlutterError? {
        guard let flutterError = result as? FlutterError else {
            XCTFail("Result should be an error")
            return nil
        }
        
        return flutterError
    }
    
    public class MockError : NSError {
        init(message: String) {
            var userInfo: [String : Any] = [:]
            userInfo[NSLocalizedDescriptionKey] = message
            
            super.init(domain: "testdomain", code: 1, userInfo: userInfo)
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    }
}
