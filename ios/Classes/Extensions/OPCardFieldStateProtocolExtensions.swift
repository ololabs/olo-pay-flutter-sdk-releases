// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  OPCardFieldStateProtocolExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/13/23.
//

import Foundation
import OloPaySDK

extension OPCardFieldStateProtocol {
    public func toDictionary() -> [String: Any] {
        return [
            DataKeys.IsValidKey: self.isValid,
            DataKeys.IsFocusedKey: self.isFirstResponder,
            DataKeys.IsEmptyKey: self.isEmpty,
            DataKeys.WasEditedKey: self.wasEdited,
            DataKeys.WasFocusedKey: self.wasFirstResponder
        ]
    }
}
