// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PKPaymentButtonStyleExcentions.swift
//  Pods
//
//  Created by Justin Anderson on 3/21/25.
//

import PassKit

extension PKPaymentButtonStyle {
    static func convert(from str: String) -> PKPaymentButtonStyle {
        switch str {
        case DataKeys.ApplePayButtonStyleBlack:
            return .black
        case DataKeys.ApplePayButtonStyleWhite:
            return .white
        case DataKeys.ApplePayButtonStyleWhiteOutline:
            return .whiteOutline
        case DataKeys.ApplePayButtonStyleAutomatic:
            if #available(iOS 14.0, *) {
                return .automatic
            } else {
                return .black
            }
        default:
            return .black
        }
    }
}
