// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCvvUpdateTokenProtocolExtensions.swift
//  olo_pay_sdk
//
//  Created by Richard Dowdy on 4/16/24.
//

import Foundation
import OloPaySDK


extension OPCvvUpdateTokenProtocol {
    public func toDictionary() -> [String: Any] {
        return [
            DataKeys.IDKey: self.id,
            DataKeys.ProductionEnvironmentKey: self.environment == .production
        ]
    }
}
