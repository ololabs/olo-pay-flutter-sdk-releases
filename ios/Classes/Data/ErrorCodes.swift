// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ErrorCodes.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/8/23.
//

import Foundation

public class ErrorCodes {
    // Method Call Rejection Codes
    public static let InvalidParameter = "InvalidParameter"
    public static let MissingParameter = "MissingParameter"
    public static let UnexpectedParameterType = "UnexpectedParameterType"
    public static let UninitializedSdk = "SdkUninitialized"
    public static let ApplePayUnsupported = "ApplePayUnsupported"
    public static let Unimplemented = "UNIMPLEMENTED"
    public static let ViewNotFound = "ViewNotFound"
    
    // Do not rename this key... it maps to an OPError type, but we also
    // use if for some other scenarios in the RN SDK
    public static let GeneralError = "generalError"
    
    // API Exception Error Codes
    public static let ApiError = "ApiError"
    public static let InvalidRequest = "InvalidRequest"
    public static let Connection = "ConnectionError"
    public static let Cancellation = "CancellationError"
    public static let Authentication = "AuthenticationError"
    
    // Card Exception Error Codes
    public static let InvalidCardDetails = "InvalidCardDetails"
    public static let InvalidNumber = "InvalidNumber"
    public static let InvalidExpiration = "InvalidExpiration"
    public static let InvalidCvv = "InvalidCVV"
    public static let InvalidPostalCode = "InvalidPostalCode"
    public static let ExpiredCard = "ExpiredCard"
    public static let CardDeclined = "CardDeclined"
    public static let ProcessingError = "ProcessingError"
    public static let UnknownCard = "UnknownCardError"
    
    // Font Error Codes
    public static let UnexpectedError = "UnexpectedError"
    public static let AssetNotFoundError = "AssetNotFoundError"
    public static let FontLoadError = "FontLoadError"
}
