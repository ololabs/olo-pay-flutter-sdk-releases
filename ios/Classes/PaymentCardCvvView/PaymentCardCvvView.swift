// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PaymentCardCvvView.swift
//  integration_test
//
//  Created by Justin Anderson on 4/10/24.
//

import Foundation
import Flutter
import UIKit
import OloPaySDK
import os.log

class PaymentCardCvvView: NSObject, FlutterPlatformView, OPPaymentCardCvvViewDelegate {
    private let _logger = OSLog.init(subsystem: Bundle.main.bundleIdentifier!, category: DataKeys.BridgePrefix)
    
    private var _customErrorMessages: CustomErrorMessages? = nil
    private let _cvvView: OPPaymentCardCvvView
    private let _methodChannel: FlutterMethodChannel
    
    init(withFrame frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        
        _cvvView = OPPaymentCardCvvView(frame: frame)
        _cvvView.displayGeneratedErrorMessages = false
        
        let channelName = "\(DataKeys.CvvBaseMethodChannelKey)\(viewId)"
        _methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall(call:result:))
        
        _cvvView.cvvDetailsDelegate = self
        
        loadCustomArgs(args: args)
    }
    
    var customErrorMessages: Dictionary<String, Any>? = nil {
        didSet {
            if let customErrorMessages: Dictionary<String, Any> = customErrorMessages {
                _customErrorMessages = CustomErrorMessages(cvvCustomErrors: customErrorMessages as NSDictionary)
            } else {
                _customErrorMessages = nil
            }
        }
    }
    
    func view() -> UIView {
        return _cvvView
    }
    
    private func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.CreateCvvTokenMethodKey:
            createCvvUpdateToken(result: result)
        case DataKeys.GetStateMethodKey:
            getState(result: result)
        case DataKeys.IsValidMethodKey:
            isValid(result: result)
        case DataKeys.IsEnabledMethodKey:
            isEnabled(result: result)
        case DataKeys.HasErrorMessageMethodKey:
            hasErrorMessage(call: call, result: result)
        case DataKeys.GetErrorMessageMethodKey:
            getErrorMessage(call: call, result: result)
        case DataKeys.ClearFieldsMethodKey:
            clear(result: result)
        case DataKeys.RequestFocusMethodKey:
            requestFocus(result: result)
        case DataKeys.ClearFocusMethodKey:
            clearFocus(result: result)
        case DataKeys.RefreshUiMethodKey:
            refreshUI(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func createCvvUpdateToken(result: @escaping FlutterResult) {
        guard let params = _cvvView.getCvvTokenParams() else {
            result(FlutterError(code: ErrorCodes.InvalidCvv, message: getErrorMessage(false), details: nil))
            return
        }
        
        OloPayAPI().createCvvUpdateToken(with: params) { cvvToken, error in
            if (error != nil) {
                rejectError(error: error!, result: result)
                return
            }

            guard let cvvToken = cvvToken else {
                result(FlutterError(code: ErrorCodes.GeneralError, message: "Unexpected error occurred", details: nil))
                return
            }

            result(cvvToken.toDictionary())
        }
    }
    
    private func getState(result: @escaping FlutterResult) {
        result(_cvvView.fieldState.toDictionary())
    }
    
    private func isValid(result: @escaping FlutterResult) {
        result(_cvvView.isValid)
    }
    
    private func isEnabled(result: @escaping FlutterResult) {
        result(_cvvView.isEnabled)
    }
    
    private func hasErrorMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        do {
            let ignoreUneditedField: Bool = try args.getOrErrorResult(
                for: DataKeys.IgnoreUneditedFieldsParameterKey,
                baseError: "Unable to check for error message",
                result: result
            )
            
            result(_cvvView.hasErrorMessage(ignoreUneditedFieldErrors: ignoreUneditedField))
        } catch {
            return
        }
    }
    
    private func getErrorMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        do {
            let ignoreUneditedField: Bool = try args.getOrErrorResult(
                for: DataKeys.IgnoreUneditedFieldsParameterKey,
                baseError: "Unable to get error message",
                result: result
            )
            
            result(self.getErrorMessage(ignoreUneditedField))
        } catch {
            return
        }
    }
    
    private func getErrorMessage(_ ignoreUneditedFieldErrors: Bool = true) -> String {
        if (_cvvView.isValid || !_cvvView.hasErrorMessage(ignoreUneditedFieldErrors: ignoreUneditedFieldErrors)) {
            return ""
        }
        
        let defaultError = CustomErrorMessages.getDefaultErrorMessage(
            forCvvState: _cvvView.fieldState
        )
        
        var customError: String? = nil
        
        if let customErrorMessages = _customErrorMessages {
            customError = customErrorMessages.getCustomErrorMessage(
                for: .cvv,
                with: _cvvView.fieldState,
                ignoreUneditedFieldErrors
            )
        }

        return customError ?? defaultError
    }
    
    private func errorMessageHandler(_ cvvFieldState: OPCardFieldStateProtocol, _ ignoreUneditedFieldErrors: Bool) -> String {
        return getErrorMessage(ignoreUneditedFieldErrors)
    }
    
    private func clear(result: @escaping FlutterResult) {
        _cvvView.clear()
        result(nil)
    }
    
    private func requestFocus(result: @escaping FlutterResult) {
        result(_cvvView.becomeFirstResponder())
    }
    
    private func clearFocus(result: @escaping FlutterResult) {
        result(_cvvView.resignFirstResponder())
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
        
        if let hints = viewArgs[DataKeys.HintsArgumentsKey] as? Dictionary<String, String?> {
            if let cvvHint = hints[OPCardField.cvv.flutterBridgeValue()] as? String {
                _cvvView.placeholderText = cvvHint
            }
        }
        
        if let textStyles = viewArgs[DataKeys.TextStylesArgumentsKey] as? Dictionary<String, Any>, !textStyles.isEmpty {
            loadTextStyles(textStyles: textStyles)
        }
        
        if let backgroundStyles = viewArgs[DataKeys.BackgroundStylesArgumentsKey] as? Dictionary<String, Any>, !backgroundStyles.isEmpty {
            loadBackgroundStyles(backgroundStyles: backgroundStyles)
        }
        
        if let customErrorMessages = viewArgs[DataKeys.CustomErrorMessagesArgumentsKey] as? Dictionary<String, Any>, !customErrorMessages.isEmpty {
            if let cvvErrorMessages = customErrorMessages[OPCardField.cvv.flutterBridgeValue()] as? Dictionary<String, Any>, !cvvErrorMessages.isEmpty {
                self.customErrorMessages = cvvErrorMessages
            } else {
                self.customErrorMessages = nil
            }
        } else {
            self.customErrorMessages = nil
        }
        
        OPPaymentCardCvvView.errorMessageHandler = errorMessageHandler(_:_:)
        
        if let textAlign = viewArgs[DataKeys.TextAlignmentKey] as? String {
            let alignment = getTextAlignment(textAlign)
            _cvvView.textAlignment = alignment
        }
        
        if let isEnabled = viewArgs[DataKeys.EnabledParameterKey] as? Bool {
            _cvvView.isEnabled = isEnabled
        }
    }
    
    private func loadTextStyles(textStyles: Dictionary<String, Any>) {
        if let textColor = textStyles[DataKeys.TextColorKey] as? String, !textColor.isEmpty {
            _cvvView.cvvTextColor = UIColor(hex: textColor)
        }
        
        if let errorTextColor = textStyles[DataKeys.ErrorTextColorKey] as? String, !errorTextColor.isEmpty {
            _cvvView.errorTextColor = UIColor(hex: errorTextColor)
        }
        
        if let cursorColor = textStyles[DataKeys.CursorColorKey] as? String, !cursorColor.isEmpty {
            _cvvView.cursorColor = UIColor(hex: cursorColor)
        }
        
        if let hintTextColor = textStyles[DataKeys.HintTextColorKey] as? String, !hintTextColor.isEmpty {
            _cvvView.placeholderColor = UIColor(hex: hintTextColor)
        }
        
        if let fontSize = textStyles[DataKeys.TextSizeKey] as? Float {
            // We need a font size in order to set a font... thankfully we always send a font size from the
            // Flutter side of things
            let fontName = textStyles[DataKeys.FontNameKey] as? String
            
            var font = UIFont.systemFont(ofSize: CGFloat(fontSize))
            
            if let fontAsset = textStyles[DataKeys.FontAssetKey] as? String {
                do {
                    font = try UIFont.from(assetPath: fontAsset, with: fontName, size: fontSize)
                } catch OloError.AssetNotFoundError {
                    os_log("Font asset not found: %@", log: _logger, fontAsset)
                } catch OloError.FontLoadError {
                    os_log("Unable to load font: %@", log: _logger, fontAsset)
                } catch OloError.FontNameError {
                    os_log("Font name not found: %@", log: _logger, fontName ?? "")
                } catch {
                    os_log("Unexpected error loading font: %@", log: _logger, fontAsset)
                }
            }
            
            _cvvView.cvvFont = UIFontMetrics.default.scaledFont(for: font)
        }
    }
    
    private func loadBackgroundStyles(backgroundStyles: Dictionary<String, Any>) {
        if let backgroundColor = backgroundStyles[DataKeys.BackgroundColorKey] as? String, !backgroundColor.isEmpty {
            _cvvView.backgroundColor = UIColor(hex: backgroundColor)
        }
        
        if let borderColor = backgroundStyles[DataKeys.BorderColorKey] as? String, !borderColor.isEmpty {
            _cvvView.borderColor = UIColor(hex: borderColor)
        }
        
        if let borderWidth = backgroundStyles[DataKeys.BorderWidthKey] as? Double {
            _cvvView.borderWidth = CGFloat(borderWidth)
        }
        
        if let borderRadius = backgroundStyles[DataKeys.BorderRadiusKey] as? Double {
            _cvvView.cornerRadius = CGFloat(borderRadius)
        }
    }
    
    func fieldChanged(with state: OPCardFieldStateProtocol) {
        let args = [
            DataKeys.FieldStatesParameterKey: state.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnInputChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }

    func didBeginEditing(with state: OPCardFieldStateProtocol) {
        let args = [
            DataKeys.FieldStatesParameterKey: state.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }

    func didEndEditing(with state: OPCardFieldStateProtocol) {
        let args = [
            DataKeys.FieldStatesParameterKey: state.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }

    func validStateChanged(with state: OPCardFieldStateProtocol) {
        let args = [
            DataKeys.FieldStatesParameterKey: state.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnValidStateChangedEventHandlerKey, arguments: args)
        
        emitErrorMessage()
    }

     private func emitErrorMessage() {
        _methodChannel.invokeMethod(
            DataKeys.OnErrorMessageChangedEventHandlerKey,
            arguments: getErrorMessage(true)
        )
    }
    
    private func getTextAlignment(_ alignmentString: String) -> NSTextAlignment {
        if(alignmentString == DataKeys.AlignmentRightKey) {
            return NSTextAlignment.right
        } else if(alignmentString == DataKeys.AlignmentCenterKey) {
            return NSTextAlignment.center
        } else {
            return NSTextAlignment.left
        }
    }
}
