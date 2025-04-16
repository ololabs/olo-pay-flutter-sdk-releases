// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  ApplePayButton.swift
//  Pods
//
//  Created by Justin Anderson on 3/19/25.
//

import Foundation
import Flutter
import UIKit
import OloPaySDK
import PassKit
import os.log

class ApplePayButton: NSObject, FlutterPlatformView {
    private let _defaultCornerRadius = 8.0
    
    private let _logger = OSLog.init(
        subsystem: Bundle.main.bundleIdentifier!,
        category: DataKeys.BridgePrefix
    )
    
    private var _applePayButton: OPApplePayButton? = nil
    private var _applePayButtonStyle: PKPaymentButtonStyle? = nil
    private var _applePayButtonType: PKPaymentButtonType? = nil
    private var _applePayButtonCornerRadius: CGFloat? = nil
    private let _methodChannel: FlutterMethodChannel
    
    init(withFrame frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        let channelName = "\(DataKeys.DigitalWalletButtonBaseMethodChannelKey)\(viewId)"
        _methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall(call:result:))
        loadCustomArgs(with: frame, args: args)
    }
    
    func view() -> UIView {
        return _applePayButton!
    }
    
    private func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.RefreshUiMethodKey:
            refreshUI(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func refreshUI(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        if let creationParams = args?.getDictionary(DataKeys.CreationParameters) {
            loadCustomArgs(with: _applePayButton!.frame, args: creationParams)
        }
        
        result(nil)
    }
    
    private func loadCustomArgs(with frame: CGRect, args: Any?) {
        guard let viewArgs = args as? Dictionary<String, Any> else {
            return
        }
        
        let style =
            viewArgs[DataKeys.ApplePayButtonStyleKey] as? String ??
            DataKeys.ApplePayButtonStyleBlack
        
        let type =
            viewArgs[DataKeys.ApplePayButtonTypeKey] as? String ??
            DataKeys.ApplePayButtonTypeCheckout
        
        let cornerRadius =
            viewArgs[DataKeys.ApplePayButtonCornerRadiusKey] as? Double ??
            _defaultCornerRadius
        
        if let isEnabled = viewArgs[DataKeys.EnabledParameterKey] as? Bool {
            _applePayButton?.isEnabled = isEnabled
        }
        
        updateButton(
            with: frame,
            type: PKPaymentButtonType.convert(from: type),
            style: PKPaymentButtonStyle.convert(from: style),
            cornerRadius: cornerRadius
        )
    }
    
    private func onButtonClicked() {
        _methodChannel.invokeMethod(
            DataKeys.DigitalWalletButtonClickedEventHandlerKey,
            arguments: nil
        )
    }
    
    private func updateButton(
        with frame: CGRect,
        type: PKPaymentButtonType = .checkout,
        style: PKPaymentButtonStyle = .black,
        cornerRadius: CGFloat = 8.0
    ) {
        guard !buttonStylesMatch(type: type, style: style, cornerRadius: cornerRadius) else {
            return //Don't update if there's no change in styles
        }
        
        guard !onlyCornerRadiusChange(type: type, style: style, cornerRadius: cornerRadius) else {
            // If only the corner radius changes we can update the radius without having to
            // create a new button. This is much more efficient
            _applePayButton?.updateCornerRadius(cornerRadius: cornerRadius)
            _applePayButtonCornerRadius = cornerRadius
            return
        }
        
        _applePayButtonType = type
        _applePayButtonStyle = style
        _applePayButtonCornerRadius = cornerRadius
        
        guard _applePayButton == nil else {
            _applePayButton!.updateButton(
                type: type,
                style: style,
                cornerRadius: cornerRadius
            )
            return
        }
        
        _applePayButton = OPApplePayButton(
            frame: frame,
            type: type,
            style: style,
            cornerRadius: cornerRadius
        )
        
        _applePayButton!.onClick = onButtonClicked
    }
    
    private func buttonStylesMatch(
        type: PKPaymentButtonType,
        style: PKPaymentButtonStyle,
        cornerRadius: CGFloat
    ) -> Bool {
        return
            _applePayButtonType == type &&
            _applePayButtonStyle == style &&
            _applePayButtonCornerRadius == cornerRadius
    }
    
    private func onlyCornerRadiusChange(
        type: PKPaymentButtonType,
        style: PKPaymentButtonStyle,
        cornerRadius: CGFloat
    ) -> Bool {
        return
            _applePayButtonType == type &&
            _applePayButtonStyle == style &&
            _applePayButtonCornerRadius != cornerRadius
    }
 }
