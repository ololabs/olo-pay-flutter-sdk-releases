// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  StringExtensionTests.swift
//  RunnerTests
//
//  Created by Justin Anderson on 3/8/24.
//

import XCTest
@testable import olo_pay_sdk

final class StringExtensionTests: XCTestCase {

    func testTrim_trimsOnlyLeadingAndTrailingWhitespace() {
        let value = " This is a test    "
        let trimmedValue = value.trim()
        
        XCTAssertEqual("This is a test", trimmedValue)
    }

}
