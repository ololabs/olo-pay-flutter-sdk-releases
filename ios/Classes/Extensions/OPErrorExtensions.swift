// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPErrorExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 2/8/24.
//

import Foundation
import OloPaySDK

extension OPError {
    func flutterBridgeErrorType() -> String {
        switch self.errorType {
        case .connectionError:
            return ErrorCodes.Connection
        case .invalidRequestError:
            return ErrorCodes.InvalidRequest
        case .apiError:
            return ErrorCodes.ApiError
        case .cardError:
            return self.cardErrorType!.flutterBridgeErrorType()
        case .cancellationError:
            return ErrorCodes.Cancellation
        case .authenticationError:
            return ErrorCodes.Authentication
        case .generalError:
            return ErrorCodes.GeneralError
        case .applePayContextError:
            return ErrorCodes.GeneralError //This should never happen
        }
    }
}
