// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  CustomErrorMessages.swift
//  olo_pay_sdk
//
//  Created by Richard Dowdy on 3/5/24.
//

import Foundation
import OloPaySDK

class CustomErrorMessages {
    private let invalidCardNumber: String?
    private let emptyCardNumber: String?
    private let invalidExpiration: String?
    private let emptyExpiration: String?
    private let invalidCvv: String?
    private let emptyCvv: String?
    private let invalidPostalCode: String?
    private let emptyPostalCode: String?
    let unsupportedCardNumber: String?
    
    init(customErrorMessages: NSDictionary?) {
        self.invalidCardNumber = (customErrorMessages?[OPCardField.number.flutterBridgeValue()] as? [String:Any])?[DataKeys.invalidErrorKey] as? String
        self.emptyCardNumber = (customErrorMessages?[OPCardField.number.flutterBridgeValue()] as? [String:Any])?[DataKeys.emptyErrorKey] as? String
        self.invalidExpiration = (customErrorMessages?[OPCardField.expiration.flutterBridgeValue()] as? [String:Any])?[DataKeys.invalidErrorKey] as? String
        self.emptyExpiration = (customErrorMessages?[OPCardField.expiration.flutterBridgeValue()] as? [String:Any])?[DataKeys.emptyErrorKey] as? String
        self.invalidCvv = (customErrorMessages?[OPCardField.cvv.flutterBridgeValue()] as? [String:Any])?[DataKeys.invalidErrorKey] as? String
        self.emptyCvv = (customErrorMessages?[OPCardField.cvv.flutterBridgeValue()] as? [String:Any])?[DataKeys.emptyErrorKey] as? String
        self.invalidPostalCode = (customErrorMessages?[OPCardField.postalCode.flutterBridgeValue()] as? [String:Any])?[DataKeys.invalidErrorKey] as? String
        self.emptyPostalCode = (customErrorMessages?[OPCardField.postalCode.flutterBridgeValue()] as? [String:Any])?[DataKeys.emptyErrorKey] as? String
        self.unsupportedCardNumber = customErrorMessages?[DataKeys.unsupportedCardErrorKey] as? String
    }
    
    init(cvvCustomErrors: NSDictionary?) {
        invalidCardNumber = nil
        emptyCardNumber = nil
        invalidExpiration = nil
        emptyExpiration = nil
        invalidCvv = cvvCustomErrors?[DataKeys.invalidErrorKey] as? String
        emptyCvv = cvvCustomErrors?[DataKeys.emptyErrorKey] as? String
        invalidPostalCode = nil
        emptyPostalCode = nil
        unsupportedCardNumber = nil
    }
    
    static func getDefaultErrorMessage(
        for cardField: OPCardField,
        with state: OPCardFieldStateProtocol,
        _ ignoreUneditedFields: Bool,
        _ cardBrand: OPCardBrand? = nil
    ) -> String {
        return getDefaultErrorMessage(ignoreUneditedFields, [cardField: state], cardBrand ?? OPCardBrand.unknown)
    }
    
    static func getDefaultErrorMessage(
        _ ignoreUneditedFields: Bool,
        _ cardFields: [OPCardField: OPCardFieldStateProtocol],
        _ cardBrand: OPCardBrand
    ) -> String {
        let errorFields = getErrorFields(ignoreUneditedFields, cardFields)

        if let numberState = errorFields[.number] {
            if numberState.isEmpty {
                return OPStrings.emptyCardNumberError
            } else if cardBrand == .unsupported {
                return OPStrings.unsupportedCardError
            } else {
                return OPStrings.invalidCardNumberError
            }
        }
        
        if let expirationState = errorFields[.expiration] {
            return expirationState.isEmpty ? OPStrings.emptyExpirationError : OPStrings.invalidExpirationError
        }
        
        if let cvvState = errorFields[.cvv] {
            return cvvState.isEmpty ? OPStrings.emptyCvvError : OPStrings.invalidCvvError
        }
        
        if let postalCodeState = errorFields[.postalCode] {
            return postalCodeState.isEmpty ? OPStrings.emptyPostalCodeError : OPStrings.invalidPostalCodeError
        }
            
        return ""
    }
    
    func getCustomErrorMessage(
        for cardField: OPCardField,
        with state: OPCardFieldStateProtocol,
        _ ignoreUneditedFields: Bool,
        _ cardBrand: OPCardBrand? = nil
    ) -> String? {
        return getCustomErrorMessage(ignoreUneditedFields, [cardField: state], cardBrand ?? OPCardBrand.unknown)
    }
    
    func getCustomErrorMessage(
        _ ignoreUneditedFields: Bool,
        _ cardFields: [OPCardField: OPCardFieldStateProtocol],
        _ cardBrand: OPCardBrand
    ) -> String? {
        let errorFields = CustomErrorMessages.getErrorFields(ignoreUneditedFields, cardFields)

        if let numberState = errorFields[.number] {
            if numberState.isEmpty {
                return emptyCardNumber
            } else if cardBrand == .unsupported {
                return unsupportedCardNumber
            } else {
                return invalidCardNumber
            }
        }
        
        if let expirationState = errorFields[.expiration] {
            return (expirationState.isEmpty ? emptyExpiration : invalidExpiration)
        }
        
        if let cvvState = errorFields[.cvv] {
            return (cvvState.isEmpty ? emptyCvv : invalidCvv)
        }
        
        if let postalCodeState = errorFields[.postalCode] {
            return (postalCodeState.isEmpty ? emptyPostalCode : invalidPostalCode)
        }
            
        return nil
    }
    
    static func getErrorFields(_ ignoreUneditedFields: Bool, _ cardState: [OPCardField: OPCardFieldStateProtocol]) -> [OPCardField: OPCardFieldStateProtocol] {
        if(!ignoreUneditedFields) {
            return cardState.filter({!$0.value.isValid})
        }
        
        return cardState.filter({!$0.value.isValid && $0.value.wasEdited && $0.value.wasFirstResponder})
    }
    
}
