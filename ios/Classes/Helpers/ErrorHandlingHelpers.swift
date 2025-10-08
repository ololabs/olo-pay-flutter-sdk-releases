// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ErrorHandlingHelpers.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/8/23.
//

import Foundation
import OloPaySDK
import Flutter

func rejectError(error: Error, result: @escaping FlutterResult, defaultMessage: String = "Unexpected error occurred") {
    guard let opError = error as? OPError else {
        result(FlutterError(code: ErrorCodes.GeneralError, message: getErrorMessage(error: error, defaultMessage: defaultMessage), details: nil))
        return
    }
    
    rejectError(error: opError, result: result)
}

func rejectError(error: OPError, result: @escaping FlutterResult, defaultMessage: String = "Unexpected error occurred") {
    let errorCode = error.flutterBridgeErrorType()
    let errorMessage = getErrorMessage(error: error, defaultMessage: defaultMessage)
    
    result(FlutterError(code: errorCode, message: errorMessage, details: nil))
}

internal func getErrorMessage(error: Error, defaultMessage: String) -> String {
    return error.localizedDescription.isEmpty ? defaultMessage : error.localizedDescription
}
