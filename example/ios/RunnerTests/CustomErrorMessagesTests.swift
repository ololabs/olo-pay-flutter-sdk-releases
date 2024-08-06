// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  CustomErrorMessagesTests.swift
//  RunnerTests
//
//  Created by Richard Dowdy on 3/15/24.
//

import Foundation
import XCTest
@testable import olo_pay_sdk
@testable import OloPaySDK

final class CustomErrorMessagesTests: XCTestCase {
    
    let invalidFieldState = MockCardFieldState(
        isValid: false,
        isEmpty: false,
        wasEdited: true,
        isFirstResponder: false,
        wasFirstResponder: true
    )
    
    let emptyFieldState = MockCardFieldState(
        isValid: false,
        isEmpty: true,
        wasEdited: false,
        isFirstResponder: false,
        wasFirstResponder: false
    )
    
    let validFieldState = MockCardFieldState()
    
    func testGetDefaultErrorMessageForCardNumberField_cardBrandNil_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(for: .number, with: emptyFieldState, false, nil)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(for: .number, with: invalidFieldState, false)
        
        XCTAssertEqual(OPStrings.emptyCardNumberError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidCardNumberError, invalidMessage)
    }
    
    func testGetDefaultErrorMessageForCvvField_cardBrandNil_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(for: .cvv, with: emptyFieldState, false)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(for: .cvv, with: invalidFieldState, false, nil)
        
        XCTAssertEqual(OPStrings.emptyCvvError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidCvvError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_cardNumberField_errorFieldState_withValidCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(OPStrings.emptyCardNumberError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidCardNumberError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_cardNumberField_errorFieldState_withUnsupportedCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.unsupported)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(OPStrings.emptyCardNumberError, emptyMessage)
        XCTAssertEqual(OPStrings.unsupportedCardError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_cardNumberField_validFieldState_withValidCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: validFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_cardNumberField_validFieldState_withUnsupportedCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.number: validFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_expirationField_errorFieldState_withValidCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.discover)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(OPStrings.emptyExpirationError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidExpirationError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_expirationField_errorFieldState_withUnsupportedCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.unsupported)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(OPStrings.emptyExpirationError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidExpirationError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_expirationField_validFieldState_withValidCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: validFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_expirationField_validFieldState_withUnsupportedCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.expiration: validFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_cvvField_errorFieldState_withValidCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.amex)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.amex)
        
        XCTAssertEqual(OPStrings.emptyCvvError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidCvvError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_cvvField_errorFieldState_withUnsupportedCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.unsupported)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(OPStrings.emptyCvvError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidCvvError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_cvvField_validFieldState_withValidCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: validFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_cvvField_validFieldState_withUnsupportedCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.cvv: validFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_postalCodeField_errorFieldState_withValidCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(OPStrings.emptyPostalCodeError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidPostalCodeError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_postalCodeField_errorFieldState_withUnsupportedCardBrand_returnsDefaultErrorMessage() {
        let emptyMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.unsupported)
        
        let invalidMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(OPStrings.emptyPostalCodeError, emptyMessage)
        XCTAssertEqual(OPStrings.invalidPostalCodeError, invalidMessage)
    }
    
    func testGetDefaultErrorMessage_postalCodeField_validFieldState_withValidCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: validFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetDefaultErrorMessage_postalCodeField_validFieldState_withUnsupportedCardBrand_returnsEmptyString() {
        let errorMessage = CustomErrorMessages.getDefaultErrorMessage(false, [OPCardField.postalCode: validFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("", errorMessage)
    }
    
    func testGetCustomErrorMessage_expirationField_cardBrandNil_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(for: .expiration, with: emptyFieldState, false, nil)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(for: .expiration, with: invalidFieldState, false)
        
        XCTAssertEqual("Empty expiration", emptyMessage)
        XCTAssertEqual("Invalid expiration", invalidMessage)
    }
    
    func testGetCustomErrorMessage_cvvField_cardBrandNil_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(for: .cvv, with: emptyFieldState, false)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(for: .cvv, with: invalidFieldState, false, nil)
        
        XCTAssertEqual("Empty cvv", emptyMessage)
        XCTAssertEqual("Invalid cvv", invalidMessage)
    }
    
    func testGetCustomErrorMessage_cardNumberField_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty card",
                    DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("Empty card", emptyMessage)
        XCTAssertEqual("Invalid card", invalidMessage)
    }
    
    func testGetCustomErrorMessage_cardNumberField_missingCustomErrorMessages_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                    // DataKeys.emptyErrorKey: "Empty card", removed for testing purposes
                    // DataKeys.invalidErrorKey: "Invalid card", removed for testing purposes
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_cardNumberField_customErrorMessagesNil_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: nil,
                     DataKeys.invalidErrorKey: nil,
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_cardNumberField_customErrorMessagesEmpty_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "",
                     DataKeys.invalidErrorKey: "",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", emptyMessage)
        XCTAssertEqual("", invalidMessage)
    }
    
    func testGetCustomErrorMessage_unsupportedCardBrand_withCustomErrorMessageDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invali card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("Unsupported card", message)
    }
    
    func testGetCustomErrorMessage_unsupportedCardBrand_missingCustomErrorMessage_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invali card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ]
                // DataKeys.unsupportedCardErrorKey: "Unsupported card", removed for testing purposes
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(nil, message)
    }
    
    func testGetCustomErrorMessage_unsupportedCardBrand_customErrorMessageNil_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invali card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: NSNull()
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual(nil, message)
    }
    
    func testGetCustomErrorMessage_unsupportedCardBrand_emptyCustomErrorMessage_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invali card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: ""
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [OPCardField.number: invalidFieldState], OPCardBrand.unsupported)
        
        XCTAssertEqual("", message)
    }
    
    func testGetCustomErrorMessage_expirationField_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("Empty expiration", emptyMessage)
        XCTAssertEqual("Invalid expiration", invalidMessage)
    }
    
    func testGetCustomErrorMessage_expirationField_missingCustomErrorMessages_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    // DataKeys.emptyErrorKey: "Empty expiration", removed for testing purposes
                    // DataKeys.invalidErrorKey: "Invalid expiration", removed for testing purposes
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_expirationField_customErrorMessagesNil_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: nil,
                    DataKeys.invalidErrorKey: nil,
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_expirationField_emptyCustomErrorMessages_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "",
                    DataKeys.invalidErrorKey: "",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.expiration: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", emptyMessage)
        XCTAssertEqual("", invalidMessage)
    }
    
    func testGetCustomErrorMessage_cvvField_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("Empty cvv", emptyMessage)
        XCTAssertEqual("Invalid cvv", invalidMessage)
    }
    
    func testGetCustomErrorMessage_cvvField_missingCustomErrorMessages_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    // DataKeys.emptyErrorKey: "Empty cvv", removed for testing purposes
                    // DataKeys.invalidErrorKey: "Invalid cvv", removed for testing purposes
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_cvvField_customErrorMessagesNil_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: nil,
                     DataKeys.invalidErrorKey: nil,
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_cvvField_emptyCustomErrorMessages_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "",
                     DataKeys.invalidErrorKey: "",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.cvv: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", emptyMessage)
        XCTAssertEqual("", invalidMessage)
    }
    
    func testGetCustomErrorMessage_postalCodeField_withCustomErrorMessagesDefined_returnsCustomErrorMessage() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("Empty postal code", emptyMessage)
        XCTAssertEqual("Invalid postal code", invalidMessage)
    }
    
    func testGetCustomErrorMessage_postalCodeField_missingCustomErrorMessages_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    // DataKeys.emptyErrorKey: "Empty postal code", removed for testing purposes
                    // DataKeys.invalidErrorKey: "Invalid postal code", removed for testing purposes
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_postalCodeField_customErrorMessagesNil_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: nil,
                    DataKeys.invalidErrorKey: nil,
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual(nil, emptyMessage)
        XCTAssertEqual(nil, invalidMessage)
    }
    
    func testGetCustomErrorMessage_postalCodeField_emptyCustomErrorMessages_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "",
                    DataKeys.invalidErrorKey: "",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let emptyMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: emptyFieldState], OPCardBrand.visa)
        
        let invalidMessage = customErrorMessages.getCustomErrorMessage(false, [OPCardField.postalCode: invalidFieldState], OPCardBrand.visa)
        
        XCTAssertEqual("", emptyMessage)
        XCTAssertEqual("", invalidMessage)
    }
    
    func testGetCustomErrorMessage_emptyCardFieldFieldMap_withCustomErrorMessageDefined_returnsEmptyString() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [:], OPCardBrand.visa)
        
        XCTAssertEqual(nil, message)
    }
    
    func testGetCustomErrorMessage_emptyCardFieldFieldMap_returnsNil() {
        let customErrorMessages = CustomErrorMessages(customErrorMessages:
            [
                OPCardField.number.flutterBridgeValue(): [
                     DataKeys.emptyErrorKey: "Empty card",
                     DataKeys.invalidErrorKey: "Invalid card",
                ],
                OPCardField.expiration.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty expiration",
                    DataKeys.invalidErrorKey: "Invalid expiration",
                ],
                OPCardField.cvv.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty cvv",
                    DataKeys.invalidErrorKey: "Invalid cvv",
                ],
                OPCardField.postalCode.flutterBridgeValue(): [
                    DataKeys.emptyErrorKey: "Empty postal code",
                    DataKeys.invalidErrorKey: "Invalid postal code",
                ],
                DataKeys.unsupportedCardErrorKey: "Unsupported card"
            ]
        )
        
        let message = customErrorMessages.getCustomErrorMessage(false, [:], OPCardBrand.visa)
        
        
        XCTAssertEqual(nil, message)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsTrue_cardNumberField_invalidWasEditedWasFirstResponder_returnsCardNumberField() {
        let ignoreUneditedFields = true
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : MockCardFieldState(
                    isValid: false,
                    isEmpty: true,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.expiration: validFieldState,
                OPCardField.cvv: validFieldState,
                OPCardField.postalCode: validFieldState,
            ]
        )
        
        XCTAssertEqual(errorFields.count, 1)
        XCTAssertTrue(errorFields[OPCardField.number] != nil)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsTrue_cvvAndPostalCodeFields_invalidWasEditedWasFocused_returnsCvvAndPostalCodeFields() {
        let ignoreUneditedFields = true
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : MockCardFieldState(
                    isValid: false,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: false
                ),
                OPCardField.expiration: MockCardFieldState(
                    isValid: false,
                    isEmpty: true,
                    wasEdited: false,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.cvv: MockCardFieldState(
                    isValid: false,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.postalCode: MockCardFieldState(
                    isValid: false,
                    isEmpty: true,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
            ]
        )
        
        XCTAssertEqual(errorFields.count, 2)
        XCTAssertTrue(errorFields[OPCardField.cvv] != nil)
        XCTAssertTrue(errorFields[OPCardField.postalCode] != nil)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsTrue_allFields_invalidWasEditedWasFocused_returnsAllFields() {
        let ignoreUneditedFields = true
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : MockCardFieldState(
                    isValid: false,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.expiration: MockCardFieldState(
                    isValid: false,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.cvv: MockCardFieldState(
                    isValid: false,
                    isEmpty: true,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.postalCode: MockCardFieldState(
                    isValid: false,
                    isEmpty: true,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
            ]
        )
        
        XCTAssertEqual(errorFields.count, 4)
        XCTAssertTrue(errorFields[OPCardField.number] != nil)
        XCTAssertTrue(errorFields[OPCardField.expiration] != nil)
        XCTAssertTrue(errorFields[OPCardField.cvv] != nil)
        XCTAssertTrue(errorFields[OPCardField.postalCode] != nil)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsTrue_noFields_invalidWasEditedWasFocused_returnsNoFields() {
        let ignoreUneditedFields = true
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : validFieldState,
                OPCardField.expiration: MockCardFieldState(
                    isValid: true,
                    isEmpty: true,
                    wasEdited: false,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.cvv: MockCardFieldState(
                    isValid: true,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.postalCode: MockCardFieldState(
                    isValid: true,
                    isEmpty: true,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
            ]
        )
        
        XCTAssertEqual(errorFields.count, 0)
        XCTAssertTrue(errorFields.isEmpty)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsFalse_allValidFields_returnsEmptyMap() {
        let ignoreUneditedFields = false
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : validFieldState,
                OPCardField.expiration: validFieldState,
                OPCardField.cvv: validFieldState,
                OPCardField.postalCode: validFieldState,
            ]
        )
        
        XCTAssertEqual(errorFields.count, 0)
        XCTAssertTrue(errorFields.isEmpty)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsFalse_onlyNumberFieldInvalid_returnsOnlyNumberField() {
        let ignoreUneditedFields = false
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : invalidFieldState,
                OPCardField.expiration: validFieldState,
                OPCardField.cvv: validFieldState,
                OPCardField.postalCode: validFieldState,
            ]
        )
        
        XCTAssertEqual(errorFields.count, 1)
        XCTAssertTrue(errorFields[OPCardField.number] != nil)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsFalse_expirationAndCvvFieldsInvalid_returnsCorrectErrorFields() {
        let ignoreUneditedFields = false
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : validFieldState,
                OPCardField.expiration: invalidFieldState,
                OPCardField.cvv: invalidFieldState,
                OPCardField.postalCode: validFieldState,
            ]
        )
        
        XCTAssertEqual(errorFields.count, 2)
        XCTAssertTrue(errorFields[OPCardField.expiration] != nil)
        XCTAssertTrue(errorFields[OPCardField.cvv] != nil)
    }
    
    func testGetErrorFields_ignoreUneditedFieldsFalse_allFieldsInvalid_returnsAllErrorFields() {
        let ignoreUneditedFields = false
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : invalidFieldState,
                OPCardField.expiration: invalidFieldState,
                OPCardField.cvv: invalidFieldState,
                OPCardField.postalCode: MockCardFieldState(
                    isValid: false,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: true,
                    wasFirstResponder: true
                ),
            ]
        )
        
        XCTAssertEqual(errorFields.count, 4)
        XCTAssertTrue(errorFields[OPCardField.number] != nil)
        XCTAssertTrue(errorFields[OPCardField.expiration] != nil)
        XCTAssertTrue(errorFields[OPCardField.cvv] != nil)
        XCTAssertTrue(errorFields[OPCardField.postalCode] != nil)
    }
    
    
    func testGetErrorFields_ignoreUneditedFieldsFalse_numberFieldInvalid_expirationWasEditedAndWasFocused_returnsOnlyCardField() {
        let ignoreUneditedFields = false
        
        let errorFields = CustomErrorMessages.getErrorFields(
            ignoreUneditedFields,
            [
                OPCardField.number : invalidFieldState,
                OPCardField.expiration: MockCardFieldState(
                    isValid: true,
                    isEmpty: false,
                    wasEdited: true,
                    isFirstResponder: false,
                    wasFirstResponder: true
                ),
                OPCardField.cvv: validFieldState,
                OPCardField.postalCode: validFieldState,
            ]
        )
        
        XCTAssertEqual(errorFields.count, 1)
        XCTAssertTrue(errorFields[OPCardField.number] != nil)
    }
}
