// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  FontHelpers.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 2/16/24.
//

import Foundation
import Flutter

// Adapated from this tutorial:
// https://tonyowen.medium.com/sharing-fonts-between-flutter-and-native-a9d98517f372
func registerFont(from assetPath: String) throws -> CGFont {
    // Get the appDelegate for the app... this should never fail
    guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
        throw OloError.UnexpectedError
    }
    
    // Get the root view controller for the app... this should never fail
    guard let viewController = appDelegate.window?.rootViewController as? FlutterViewController else {
        throw OloError.UnexpectedError
    }
    
    // Get the path to the flutter font asset
    let relativeFontPath = viewController.lookupKey(forAsset: assetPath)
    guard let fullFontPath = Bundle.main.path(forResource: relativeFontPath, ofType: nil) else {
        throw OloError.AssetNotFoundError
    }
    
    // Create a data provider with the font url
    let url = URL(fileURLWithPath: fullFontPath, relativeTo: nil)
    guard let dataProvider = CGDataProvider(url: url as CFURL) else {
        throw OloError.FontLoadError
    }
    
    // Load the font
    guard let fontRef = CGFont(dataProvider) else {
        throw OloError.FontLoadError
    }
    
    // Register and return the font
    // NOTE: There isn't a great way to distinguish between fonts that have already been
    // registered and fonts that failed to be registered. We can still get the and attempt
    // to use the font reference regardless of whether the register call succeeded or failed
    CTFontManagerRegisterGraphicsFont(fontRef, nil)
    return fontRef
}
