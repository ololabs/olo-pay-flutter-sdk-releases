// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PaymentCardDetailsFormView.swift
//  olo_pay_sdk
//
//  Created by Richard Dowdy on 2/27/25.
//

import Foundation
import Flutter
import UIKit
import OloPaySDK
import os.log

class PaymentCardDetailsFormView: NSObject, FlutterPlatformView, OPPaymentCardDetailsFormDelegate {
    private var _formInputView: OPPaymentCardDetailsForm
    private let _methodChannel: FlutterMethodChannel
    
    init(withFrame frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        _formInputView = OPPaymentCardDetailsForm(frame: frame)

        let channelName = "\(DataKeys.FormBaseMethodChannelKey)\(viewId)"
        _methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall(call:result:))
        _formInputView.cardDetailsDelegate = self
        
        loadCustomArgs(args: args)
    }
    
    func view() -> UIView {
        return _formInputView
    }
    
    func isValidChanged(_ isValid: Bool) {
        let args = [
            DataKeys.IsValidKey: isValid
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnValidStateChangedEventHandlerKey, arguments: args)
    }
    
    private func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.CreatePaymentMethodKey:
            createPaymentMethod(result: result)
        case DataKeys.IsValidMethodKey:
            isValid(result: result)
        case DataKeys.RequestFocusMethodKey:
            requestFocus(call: call, result: result)
        case DataKeys.ClearFocusMethodKey:
            clearFocus(result: result)
        case DataKeys.IsEnabledMethodKey:
            isEnabled(result: result)
        case DataKeys.RefreshUiMethodKey:
            refreshUI(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
        
        private func createPaymentMethod(result: @escaping FlutterResult) {
            guard let params = _formInputView.getPaymentMethodParams() else {
                result(FlutterError(code: ErrorCodes.InvalidCardDetails, message: "Card details are invalid", details: nil))
                return
            }
            
            OloPayAPI().createPaymentMethod(with: params) { paymentMethod, error in
                if (error != nil) {
                    rejectError(error: error!, result: result)
                    return
                }

                guard let paymentMethod = paymentMethod else {
                    result(FlutterError(code: ErrorCodes.GeneralError, message: "Unexpected error occurred", details: nil))
                    return
                }

                result(paymentMethod.toDictionary())
            }
        }
    
    private func isValid(result: @escaping FlutterResult) {
        result(_formInputView.isValid)
    }
    
    private func requestFocus(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        do {
            let focusField = try args?.getStringOrErrorResult(
                for: DataKeys.FocusFieldParameterKey,
                withDefault: DataKeys.CardNumberFieldValueKey,
                baseError: "Unable to set focus",
                acceptEmptyValue: false,
                result: result
                )

            _formInputView.becomeFirstResponder(at: OPCardField.from(value: focusField ?? DataKeys.CardNumberFieldValueKey))
            result(nil)
        } catch {
            return
        }
    }
    
    private func clearFocus(result: @escaping FlutterResult) {
        let _ = _formInputView.resignFirstResponder()
        result(nil)
    }

    private func isEnabled(result: @escaping FlutterResult) {
        result(_formInputView.isUserInteractionEnabled)
    }
    
    private func refreshUI(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        if let creationParams = args?.getDictionary(DataKeys.CreationParameters) {
            loadCustomArgs(args: creationParams)
        }
        
        result(nil)
    }
    
    private func loadCustomArgs(args: Any?) {
        guard let viewArgs = args as? Dictionary<String, Any> else {
            return
        }
        
        if let backgroundStyles = viewArgs[DataKeys.BackgroundStylesArgumentsKey] as? Dictionary<String, Any>, !backgroundStyles.isEmpty {
            loadBackgroundStyles(backgroundStyles: backgroundStyles)
        }
        
        if let textStyles = viewArgs[DataKeys.TextStylesArgumentsKey] as? Dictionary<String, Any>, !textStyles.isEmpty {
            loadTextStyles(textStyles: textStyles)
        }
        
        if let isEnabled = viewArgs[DataKeys.EnabledParameterKey] as? Bool {
            _formInputView.isUserInteractionEnabled = isEnabled
        }
    }
    
   
    private func loadBackgroundStyles(backgroundStyles: Dictionary<String, Any>) {
        if let backgroundColor = backgroundStyles[DataKeys.BackgroundColorKey] as? String, !backgroundColor.isEmpty {
            _formInputView.backgroundColor = UIColor(hex: backgroundColor)
        }
    }
    
    private func loadTextStyles(textStyles: Dictionary<String, Any>) {
        if let tintColor = textStyles[DataKeys.CursorColorKey] as? String, !tintColor.isEmpty {
            _formInputView.tintColor = UIColor(hex: tintColor)
        }
    }
}
