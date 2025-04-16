// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCardErrorTypeExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 2/8/24.
//

import Foundation
import OloPaySDK

extension OPCardErrorType {
    func flutterBridgeErrorType() -> String {
        switch self {
        case .invalidNumber:
            return ErrorCodes.InvalidNumber
        case .invalidExpMonth:
            return ErrorCodes.InvalidExpiration
        case .invalidExpYear:
            return ErrorCodes.InvalidExpiration
        case .invalidCvv:
            return ErrorCodes.InvalidCvv
        case .invalidZip:
            return ErrorCodes.InvalidPostalCode
        case .expiredCard:
            return ErrorCodes.ExpiredCard
        case .cardDeclined:
            return ErrorCodes.CardDeclined
        case .processingError:
            return ErrorCodes.ProcessingError
        case .unknownCardError:
            return ErrorCodes.UnknownCard
        }
    }
}
