// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  UIFontExtensions.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 2/22/24.
//

import Foundation

extension UIFont {
    public static func from(assetPath: String, with name: String?, size: Float) throws -> UIFont {
        let cgFont = try registerFont(from: assetPath)
        let cgSize = CGFloat(size)
        
        if let name = name, !name.isEmpty {
            if let uiFont = UIFont(name: name, size: cgSize) {
                return uiFont
            }
        }
        
        if let psName = cgFont.postScriptName as? String, !psName.isEmpty {
            if let uiFont = UIFont(name: psName, size: cgSize) {
                return uiFont
            }
        }
        
        if let fullName = cgFont.fullName as? String, !fullName.isEmpty {
            if let uiFont = UIFont(name: fullName, size: cgSize) {
                return uiFont
            }
        }
        
        throw OloError.FontNameError
    }
}
