// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCardFieldExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/13/23.
//

import Foundation
import OloPaySDK

extension OPCardField {
    func flutterBridgeValue() -> String {
        switch self {
        case .number:
            return DataKeys.CardNumberFieldValueKey
        case .expiration:
            return DataKeys.ExpirationFieldValueKey
        case .cvv:
            return DataKeys.CvvFieldValueKey
        case .postalCode:
            return DataKeys.PostalCodeFieldValueKey
        case .unknown:
            return ""
        }
    }
}
