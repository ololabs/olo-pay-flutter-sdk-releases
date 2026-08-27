// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  StringExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 3/6/24.
//

import Foundation

extension String {
    func trim() -> String {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
