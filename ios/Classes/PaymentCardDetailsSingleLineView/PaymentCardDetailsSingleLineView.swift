// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  PaymentCardDetailsSingleLineView.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/7/23.
//

import Foundation
import Flutter
import UIKit
import OloPaySDK
import os.log

class PaymentCardDetailsSingleLineView: NSObject, FlutterPlatformView, OPPaymentCardDetailsViewDelegate {
    private let _logger = OSLog.init(subsystem: Bundle.main.bundleIdentifier!, category: DataKeys.BridgePrefix)
    
    private var _customErrorMessages: CustomErrorMessages? = nil
    private var _cardInputView: OPPaymentCardDetailsView
    private let _methodChannel: FlutterMethodChannel
    
    init(withFrame frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        _cardInputView = OPPaymentCardDetailsView(frame: frame)
        _cardInputView.displayGeneratedErrorMessages = false
        
        let channelName = "\(DataKeys.SingleLineBaseMethodChannelKey)\(viewId)"
        _methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        
        super.init()
        _methodChannel.setMethodCallHandler(onMethodCall(call:result:))
        
        _cardInputView.cardDetailsDelegate = self
        
        loadCustomArgs(args: args)
    }
    
    var customErrorMessages: Dictionary<String, Any>? = nil {
        didSet {
            if let customErrorMessages: Dictionary<String, Any> = customErrorMessages {
                _customErrorMessages = CustomErrorMessages(customErrorMessages: customErrorMessages as NSDictionary)
            } else {
                _customErrorMessages = nil
            }
        }
    }
    
    func view() -> UIView {
        return _cardInputView
    }
    
    private func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.CreatePaymentMethodKey:
            createPaymentMethod(result: result)
        case DataKeys.GetStateMethodKey:
            getState(result: result)
        case DataKeys.IsValidMethodKey:
            isValid(result: result)
        case DataKeys.GetCardTypeMethodKey:
            getCardType(result: result)
        case DataKeys.IsEnabledMethodKey:
            isEnabled(result: result)
        case DataKeys.HasErrorMessageMethodKey:
            hasErrorMessage(call: call, result: result)
        case DataKeys.GetErrorMessageMethodKey:
            getErrorMessage(call: call, result: result)
        case DataKeys.ClearFieldsMethodKey:
            clearFields(result: result)
        case DataKeys.RequestFocusMethodKey:
            requestFocus(call: call, result: result)
        case DataKeys.ClearFocusMethodKey:
            clearFocus(result: result)
        case DataKeys.RefreshUiMethodKey:
            refreshUI(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func createPaymentMethod(result: @escaping FlutterResult) {
        guard let params = _cardInputView.getPaymentMethodParams() else {
            result(FlutterError(code: getErrorCode(), message: getErrorMessage(false), details: nil))
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
    
    private func getState(result: @escaping FlutterResult) {
        result(_cardInputView.fieldStates.toDictionary())
    }
    
    private func isValid(result: @escaping FlutterResult) {
        result(_cardInputView.isValid)
    }
    
    private func getCardType(result: @escaping FlutterResult) {
        result(_cardInputView.cardType.description)
    }
    
    private func isEnabled(result: @escaping FlutterResult) {
        result(_cardInputView.isEnabled)
    }
    
    private func hasErrorMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        guard let ignoreUneditedFields: Bool = args?.get(DataKeys.IgnoreUneditedFieldsParameterKey) else {
            result(FlutterError(
                code: ErrorCodes.MissingParameter,
                message: "Missing Parameter \(DataKeys.IgnoreUneditedFieldsParameterKey)",
                details: nil)
            )
            return
        }
        
        result(_cardInputView.hasErrorMessage(ignoreUneditedFields))
    }
    
    private func getErrorMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        do {
            let ignoreUneditedFields: Bool = try args.getOrErrorResult(
                for: DataKeys.IgnoreUneditedFieldsParameterKey,
                baseError: "Unable to get error message",
                result: result
            )
            
            result(self.getErrorMessage(ignoreUneditedFields))
        } catch {
            return
        }
    }
    
    private func getErrorMessage(_ ignoreUneditedFieldErrors: Bool = true) -> String {
        if (_cardInputView.isValid || !_cardInputView.hasErrorMessage(ignoreUneditedFieldErrors)) {
            return ""
        }
        
        let defaultError = CustomErrorMessages.getDefaultErrorMessage(
            ignoreUneditedFieldErrors,
            _cardInputView.fieldStates,
            _cardInputView.cardType
        )
            
        var customError: String? = nil
        
        if let customErrorMessages = _customErrorMessages {
            customError = customErrorMessages.getCustomErrorMessage(
                ignoreUneditedFieldErrors,
                _cardInputView.fieldStates,
                _cardInputView.cardType
            )
        }
        
        return customError ?? defaultError
    }
    
    private func errorMessageHandler(_ cardState: NSDictionary, _ cardBrand: OPCardBrand, _ ignoreUneditedFieldErrors: Bool) -> String {
        return getErrorMessage(ignoreUneditedFieldErrors)
    }
    
    private func clearFields(result: @escaping FlutterResult) {
        _cardInputView.clear()
        result(nil)
    }
    
    private func requestFocus(call: FlutterMethodCall?, result: @escaping FlutterResult) {
        let args = call?.arguments as? Dictionary<String, Any>
        do {
            let focusField = try args?.getStringOrErrorResult(
                for: DataKeys.FocusFieldParameterKey,
                withDefault: DataKeys.CardNumberFieldValueKey,
                baseError: "Unable to set focus",
                acceptEmptyValue: false,
                result: result
                )
            _cardInputView.becomeFirstResponder(at: OPCardField.from(value: focusField ?? DataKeys.CardNumberFieldValueKey))
            result(nil)
        } catch {
            return
        }
    }
    
    private func clearFocus(result: @escaping FlutterResult) {
        _cardInputView.resignFirstResponder()
        result(nil)
    }
    
    private func refreshUI(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        if let creationParams = args?.getDictionary(DataKeys.CreationParameters) {
            loadCustomArgs(args: creationParams)
        }
        
        result(nil)
    }
    
    private func getErrorCode() -> String {
        if !_cardInputView.fieldStates[OPCardField.number]!.isValid {
            return ErrorCodes.InvalidNumber
        } else if !_cardInputView.fieldStates[OPCardField.expiration]!.isValid {
            return ErrorCodes.InvalidExpiration
        } else if !_cardInputView.fieldStates[OPCardField.cvv]!.isValid {
            return ErrorCodes.InvalidCvv
        } else if !_cardInputView.fieldStates[OPCardField.postalCode]!.isValid {
            return ErrorCodes.InvalidPostalCode
        }
        
        return ErrorCodes.InvalidCardDetails
    }
    
    func paymentCardDetailsViewDidChange(with fieldStates: NSDictionary, isValid: Bool) {
        let args = [
            DataKeys.IsValidKey: isValid,
            DataKeys.FieldStatesParameterKey: _cardInputView.fieldStates.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnInputChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }
    
    func paymentCardDetailsViewFieldDidBeginEditing(with fieldStates: NSDictionary, field: OPCardField, isValid: Bool) {
        let args = [
            DataKeys.FocusedFieldParameterKey: field.flutterBridgeValue(),
            DataKeys.IsValidKey: isValid,
            DataKeys.FieldStatesParameterKey: _cardInputView.fieldStates.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }
    
    func paymentCardDetailsViewDidEndEditing(with fieldStates: NSDictionary, isValid: Bool) {
        let args = [
            DataKeys.FocusedFieldParameterKey: OPCardField.unknown.flutterBridgeValue(),
            DataKeys.IsValidKey: isValid,
            DataKeys.FieldStatesParameterKey: _cardInputView.fieldStates.toDictionary()
        ] as [String : Any]
        
        _methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, arguments: args)
        emitErrorMessage()
    }
    
    func paymentCardDetailsViewIsValidChanged(with fieldStates: NSDictionary, isValid: Bool) {
        let args = [
            DataKeys.IsValidKey: isValid,
            DataKeys.FieldStatesParameterKey: _cardInputView.fieldStates.toDictionary()
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
    
    private func loadCustomArgs(args: Any?) {
        guard let viewArgs = args as? Dictionary<String, Any> else {
            return
        }
        
        if let hints = viewArgs[DataKeys.HintsArgumentsKey] as? Dictionary<String, String?> {
            loadHints(hints: hints)
        }
        
        if let textStyles = viewArgs[DataKeys.TextStylesArgumentsKey] as? Dictionary<String, Any>, !textStyles.isEmpty {
            loadTextStyles(textStyles: textStyles)
        }
        
        if let backgroundStyles = viewArgs[DataKeys.BackgroundStylesArgumentsKey] as? Dictionary<String, Any>, !backgroundStyles.isEmpty {
            loadBackgroundStyles(backgroundStyles: backgroundStyles)
        }
        
        if let customErrorMessages = viewArgs[DataKeys.CustomErrorMessagesArgumentsKey] as? Dictionary<String, Any>, !customErrorMessages.isEmpty {
            self.customErrorMessages = customErrorMessages
        } else {
            self.customErrorMessages = nil
        }
        
        if let isEnabled = viewArgs[DataKeys.EnabledParameterKey] as? Bool {
            _cardInputView.isEnabled = isEnabled
        }
     
        OPPaymentCardDetailsView.errorMessageHandler = errorMessageHandler(_:_:_:)
    }
    
    private func loadHints(hints: Dictionary<String, String?>) {
        if let numberHint = hints[OPCardField.number.flutterBridgeValue()] {
            _cardInputView.numberPlaceholder = numberHint
        }
        
        if let expirationHint = hints[OPCardField.expiration.flutterBridgeValue()] {
            _cardInputView.expirationPlaceholder = expirationHint
        }
        
        if let cvvHint = hints[OPCardField.cvv.flutterBridgeValue()] {
            _cardInputView.cvvPlaceholder = cvvHint
        }
        
        if let postalCodeHint = hints[OPCardField.postalCode.flutterBridgeValue()] {
            _cardInputView.postalCodePlaceholder = postalCodeHint
        }
    }
    
    private func loadTextStyles(textStyles: Dictionary<String, Any>) {
        if let textColor = textStyles[DataKeys.TextColorKey] as? String, !textColor.isEmpty {
            _cardInputView.textColor = UIColor(hex: textColor)
        }
        
        if let errorTextColor = textStyles[DataKeys.ErrorTextColorKey] as? String, !errorTextColor.isEmpty {
            _cardInputView.textErrorColor = UIColor(hex: errorTextColor)
        }
        
        if let cursorColor = textStyles[DataKeys.CursorColorKey] as? String, !cursorColor.isEmpty {
            _cardInputView.cursorColor = UIColor(hex: cursorColor)
        }
        
        if let hintTextColor = textStyles[DataKeys.HintTextColorKey] as? String, !hintTextColor.isEmpty {
            _cardInputView.placeholderColor = UIColor(hex: hintTextColor)
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
            
            _cardInputView.font = UIFontMetrics.default.scaledFont(for: font)
        }
    }
    
    private func loadBackgroundStyles(backgroundStyles: Dictionary<String, Any>) {
        if let backgroundColor = backgroundStyles[DataKeys.BackgroundColorKey] as? String, !backgroundColor.isEmpty {
            _cardInputView.backgroundColor = UIColor(hex: backgroundColor)
        }
        
        if let borderColor = backgroundStyles[DataKeys.BorderColorKey] as? String, !borderColor.isEmpty {
            _cardInputView.borderColor = UIColor(hex: borderColor)
        }
        
        if let borderWidth = backgroundStyles[DataKeys.BorderWidthKey] as? Double {
            _cardInputView.borderWidth = CGFloat(borderWidth)
        }
        
        if let borderRadius = backgroundStyles[DataKeys.BorderRadiusKey] as? Double {
            _cardInputView.cornerRadius = CGFloat(borderRadius)
        }
    }
}
