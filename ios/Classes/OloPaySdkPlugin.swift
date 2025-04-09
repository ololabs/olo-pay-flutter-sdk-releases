// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import Flutter
import UIKit
import os
import os.log

import OloPaySDK
import PassKit

public class OloPaySdkPlugin: NSObject, FlutterPlugin, OPApplePayLauncherDelegate {
    private let _logger = OSLog.init(subsystem: Bundle.main.bundleIdentifier!, category: DataKeys.BridgePrefix)
    
    private let _sdkInitializedSemaphore = DispatchSemaphore(value: 1)
    private let _applePayInitializedSemaphore = DispatchSemaphore(value: 1)
    private let _sdkInitializingSemaphore = DispatchSemaphore(value: 1)
    private let _applePaySemaphore = DispatchSemaphore(value: 1)
    
    private var _applePayLauncher: OPApplePayLauncher = OPApplePayLauncher()
    private var _applePayPaymentMethod: OloPaySDK.OPPaymentMethodProtocol? = nil
    private var _initializeMetadataCalled = false
    private var _hasEmittedDigitalWalletReadyEvent = false
    
    private static var _methodChannel: FlutterMethodChannel? = nil

    //NOTE: Not private for testing purposes
    internal var _applePayResult: FlutterResult? = nil
    
    // WARNING: NEVER ACCESS/MODIFY THESE VARIABLE DIRECTLY. USE THREAD-SAFE GETTERS AND SETTERS
    private var _sdkInitialized = false
    private var _applePayConfig: OPApplePayConfiguration? = nil

    var sdkInitialized: Bool {
        get {
            return controlledReturn(with: _sdkInitializedSemaphore) {
                return self._sdkInitialized
            }
        }
        
        set(newValue) {
            let previousReadyState = applePayReady
            controlledExecute(with: _sdkInitializedSemaphore) { self._sdkInitialized = newValue }
            self.emitDigitalWalletReadyEvent(previousReadyState)
        }
    }
    
    var applePayConfig: OPApplePayConfiguration? {
        get {
            return controlledReturn(with: _applePayInitializedSemaphore) {
                return self._applePayConfig
            }
        }
        
        set(newValue) {
            let previousReadyState = applePayReady
            
            controlledExecute(with: _applePayInitializedSemaphore) {
                self._applePayConfig = newValue
                self._applePayLauncher.configuration = newValue
            }
            
            self.emitDigitalWalletReadyEvent(previousReadyState)
        }
    }
    
    var applePayInitialized: Bool {
        get { applePayConfig != nil }
    }
    
    var applePayReady: Bool {
        get {
            return sdkInitialized && applePayInitialized && OPApplePayLauncher.canMakePayments()
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        _methodChannel = FlutterMethodChannel(name: DataKeys.OloPaySdkMethodChannelKey, binaryMessenger: registrar.messenger())
        
        let instance = OloPaySdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: _methodChannel!)
        
        let messenger = registrar.messenger()
        
        registrar.register(
            PaymentCardDetailsSingleLineViewFactory(messenger: messenger),
            withId: DataKeys.PaymentCardDetailsSingleLineViewKey
        )
        
        registrar.register(
            PaymentCardDetailsFormViewFactory(messenger: messenger),
            withId: DataKeys.PaymentCardDetailsFormViewKey
        )
        
        registrar.register(
            PaymentCardCvvViewFactory(messenger: messenger),
            withId: DataKeys.PaymentCardCvvViewKey
        )
        
        registrar.register(
            ApplePayButtonFactory(messenger: messenger),
            withId: DataKeys.DigitalWalletButtonViewKey
        )
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.InitializeOloPayMethodKey:
            initializeOloPay(call: call, result: result)
        case DataKeys.InitializeMetadataMethodKey:
            initializeMetadata(call: call, result: result)
        case DataKeys.InitializeDigitalWalletMethodKey:
            initializeDigitalWallet(call: call, result: result)
        case DataKeys.IsInitializedMethodKey:
            isSdkInitialized(result: result)
        case DataKeys.IsDigitalWalletReadyMethodKey:
            isDigitalWalletReady(result: result)
        case DataKeys.UpdateDigitalWalletConfigurationMethodKey:
            updateDigitalWalletConfiguration(call: call, result: result)
        case DataKeys.CreateDigitalWalletPaymentMethod:
            createDigitalWalletPaymentMethod(call: call, result: result)
        case DataKeys.GetFontNamesMethodKey:
            getFontNamesForAssets(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeOloPay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        dispatchToBackgroundThread(with: _sdkInitializingSemaphore, autoRelease: false) {
            self.sdkInitialized = false
            let args = call.arguments as? Dictionary<String, Any>

            var productionEnvironment: Bool = OloPaySdkPlugin.defaultProductionEnvironment
            if args != nil {
                do {
                    productionEnvironment = try args!.getOrErrorResult(
                        for: DataKeys.ProductionEnvironmentKey,
                        withDefault: OloPaySdkPlugin.defaultProductionEnvironment,
                        baseError: "Unable to initialize OloPaySdk",
                        result: result
                    )
                } catch {
                    self._sdkInitializingSemaphore.signal()
                    return
                }
            }
            
            OloPayApiInitializer().setup(for: productionEnvironment ? .production : .test) {
                self.sdkInitialized = true
                self._sdkInitializingSemaphore.signal()
                result(nil)
            }
        }
    }
    
    private func initializeDigitalWallet(call: FlutterMethodCall, result: @escaping FlutterResult) {
        updateApplePayConfiguration(call: call, result: result, baseError: "Unable to initialize Apple Pay")
    }
    
    private func updateDigitalWalletConfiguration(call: FlutterMethodCall, result: @escaping FlutterResult) {
        updateApplePayConfiguration(call: call, result: result, baseError: "Unable to update Apple Pay configuration")
    }
    
    private func updateApplePayConfiguration(call: FlutterMethodCall, result: @escaping FlutterResult, baseError: String) {
        _applePayLauncher.delegate = self
        
        dispatchToBackgroundThread(with: _applePaySemaphore) {
            guard self.sdkInitialized else {
                let error = "\(baseError): Olo Pay SDK has not been initialized"
                result(FlutterError(code: ErrorCodes.UninitializedSdk, message: error, details: nil))
                return
            }
            
            self.applePayConfig = nil
            
            guard let newConfiguration = self.getApplePayConfig(
                args: call.arguments as? Dictionary<String, Any>,
                result: result,
                baseError: baseError
            ) else {
                return
            }
            
            self.applePayConfig = newConfiguration
            result(nil)
        }
    }
    
    private func initializeMetadata(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        if (!_initializeMetadataCalled) {
            _initializeMetadataCalled = true
            
            var hybridVersion = defaultVersionString
            var hybridBuildType = DataKeys.HybridBuildTypeInternalValue
            
            if args != nil {
                let baseError = "Unable to initialize metadata"
                
                do {
                    hybridVersion = try args!.getStringOrErrorResult(
                        for: DataKeys.HybridSdkVersionKey,
                        withDefault: defaultVersionString,
                        baseError: baseError,
                        acceptEmptyValue: false,
                        result: result
                    )
                } catch {
                    return
                }
                                
                do {
                    hybridBuildType = try args!.getStringOrErrorResult(
                        for: DataKeys.HybridBuildTypeKey,
                        withDefault: DataKeys.HybridBuildTypeInternalValue,
                        baseError: baseError,
                        acceptEmptyValue: false,
                        result: result
                    )
                } catch {
                    return
                }
            }
            
            setSdkWrapperInfo(version: hybridVersion, buildType: hybridBuildType)
        }

        result(nil)
    }

    private func getFontNamesForAssets(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let baseError = "Unable to get font names"
        
        guard let args = call.arguments as? Dictionary<String, Any> else {
            let message = "\(baseError): Missing parameter \(DataKeys.FontAssetListKey)"
            
            result(FlutterError(
                code: ErrorCodes.MissingParameter,
                message: message,
                details: nil
            ))
            
            return
        }
        
        var fontAssets: [Any] = []
        do {
            fontAssets = try args.getOrErrorResult(
                for: DataKeys.FontAssetListKey,
                baseError: baseError,
                result: result)
        } catch {
            return
        }
                
        if (!registerFontAssets(assets: fontAssets, result: result)) {
            return
        }
        
        // Return font data for all installed fonts because there is no way to single out JUST the
        // fonts that were dynamically installed
        var fontData: [String : Any] = [:]
        UIFont.familyNames.forEach { familyName in
            fontData.updateValue(UIFont.fontNames(forFamilyName: familyName), forKey: familyName)
        }
        
        result(fontData)
    }
    
    private func registerFontAssets(assets assetList: [Any], result: @escaping FlutterResult) -> Bool {
        var success = true
        
        for asset in assetList {
            guard let fontAsset = asset as? String, !fontAsset.isEmpty else {
                success = false
                let error = "Unable to load font asset. Asset is not a string or is empty"
                result(FlutterError(code: ErrorCodes.InvalidParameter, message: error, details: nil))
                break
            }
            
            do {
                let _ = try registerFont(from: fontAsset)
            } catch OloError.AssetNotFoundError {
                success = false
                result(FlutterError(code: ErrorCodes.AssetNotFoundError, message: "Unable to find font asset: \(fontAsset)", details: nil))
                break
            } catch OloError.FontLoadError {
                success = false
                result(FlutterError(code: ErrorCodes.FontLoadError, message: "Unable to load font asset: \(fontAsset)", details: nil))
                break
            } catch { // OloError.UnexpectedError
                success = false
                result(FlutterError(code: ErrorCodes.UnexpectedError, message: "Unexpected asset error: \(fontAsset)", details: nil))
                break
            }
        }
        
        return success
    }
    
    private func getApplePayConfig(
        args: [String : Any?]?,
        result: @escaping FlutterResult,
        baseError: String
    ) -> OPApplePayConfiguration? {
        do {
            guard let applePayArgs = args else {
                let message = "\(baseError): Missing parameter '\(DataKeys.ApplePayMerchantIdParameterKey)'"
                result(FlutterError(code: ErrorCodes.MissingParameter, message: message, details: nil))
                return nil
            }
            
            let merchantId = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.ApplePayMerchantIdParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            let companyLabel = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.ApplePayCompanyLabelParameterKey,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            let currencyCodeString = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCurrencyCodeParameterKey,
                withDefault: OloPaySdkPlugin.defaultCurrencyCode.description,
                baseError: baseError,
                acceptEmptyValue: true,
                result: result
            ).lowercased()
            
            // These are the only two currencies we support currently
            // NOTE: We should add a "from()" method on OPCurrencyCode in the iOS SDK to avoid having to do this
            guard currencyCodeString == "usd" || currencyCodeString == "cad" else {
                result(FlutterError(
                    code: ErrorCodes.UnexpectedParameterType,
                    message: "\(baseError): \(currencyCodeString.uppercased()) is not supported",
                    details: nil
                ))
                
                return nil
            }
            
            var currencyCode = OloPaySdkPlugin.defaultCurrencyCode
            if currencyCodeString == "cad" {
                currencyCode = .cad
            }
            
            let countryCode = try applePayArgs.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCountryCodeParameterKey,
                withDefault: OloPaySdkPlugin.defaultCountryCode,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result
            )
            
            let fullBillingAddressRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletFullBillingAddressRequired,
                withDefault: OloPaySdkPlugin.defaultFullBillingAddressRequired,
                baseError: baseError,
                result: result
            )
            
            let phoneNumberRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletPhoneNumberRequired,
                withDefault: OloPaySdkPlugin.defaultPhoneNumberRequired,
                baseError: baseError,
                result: result
            )
            
            let fullNameRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletFullNameRequired,
                withDefault: OloPaySdkPlugin.defaultFullNameRequired,
                baseError: baseError,
                result: result
            )
            
            let emailRequired = try applePayArgs.getOrErrorResult(
                for: DataKeys.DigitalWalletEmailRequired,
                withDefault: OloPaySdkPlugin.defaultEmailRequired,
                baseError: baseError,
                result: result
            )
            
            return OPApplePayConfiguration(
                merchantId: merchantId,
                companyLabel: companyLabel,
                currencyCode: currencyCode,
                countryCode: countryCode,
                emailRequired: emailRequired,
                phoneNumberRequired: phoneNumberRequired,
                fullNameRequired: fullNameRequired,
                fullBillingAddressRequired: fullBillingAddressRequired
            )
        } catch {
            return nil
        }
    }
    
    private func createDigitalWalletPaymentMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let baseError = "Unable to create payment method"
        
        guard sdkInitialized else {
            let error = "\(baseError): Olo Pay SDK has not been initialized"
            result(FlutterError(code: ErrorCodes.UninitializedSdk, message: error, details: nil))
            return
        }

        guard let args = call.arguments as? Dictionary<String, Any> else {
            let message = "\(baseError): Missing parameter \(DataKeys.DigitalWalletAmountParameterKey)"
            
            result(FlutterError(
                code: ErrorCodes.MissingParameter,
                message: message,
                details: nil
            ))
            return
        }
        
        dispatchToQos(on: .userInteractive, with: _applePaySemaphore, autoRelease: false) {
            var amountDouble: Double = 0.0
            var validateLineItems: Bool
            var lineItems: [PKPaymentSummaryItem]? = nil
            do {
                amountDouble = try args.getOrErrorResult(
                    for: DataKeys.DigitalWalletAmountParameterKey,
                    baseError: baseError,
                    result: result)
                
                validateLineItems = try args.getOrErrorResult(
                    for: DataKeys.ValidateLineItemsKey,
                    baseError: baseError,
                    result: result
                )
                
                lineItems = try self.getLineItemsFromFlutterArgs(
                    args: args,
                    baseError: baseError,
                    result: result
                )
            } catch {
                self.applePayCleanup()
                return
            }
            
            guard amountDouble >= 0 else {
                let error = "\(baseError): \(DataKeys.DigitalWalletAmountParameterKey) cannot be negative"
                result(FlutterError(code: ErrorCodes.InvalidParameter, message: error, details: nil))
                self.applePayCleanup()
                return
            }
            
            // NOTE: This canMakePayments() check is moved here so we can
            //       test the logic around parameters passed into this call.
            //       We cannot write unit tests for anything beyond this point.
            guard self.applePayReady else {
                let error = "\(baseError): Apple Pay is not ready"
                result(FlutterError(code: ErrorCodes.DigitalWalletNotReady, message: error, details: nil))
                self.applePayCleanup()
                return
            }
        
            let amount = NSDecimalNumber(decimal: Decimal(amountDouble))
            
            var errorMessage: String
            var errorCode: String = ""
            do {
                try self._applePayLauncher.present(for: amount, with: lineItems, validateLineItems: validateLineItems)
                self._applePayResult = result
                return
            } catch OPApplePayLauncherError.applePayNotSupported {
                errorCode = ErrorCodes.ApplePayUnsupported
                errorMessage = "Apple Pay is not supported on this device"
            } catch OPApplePayLauncherError.configurationNotSet {
                errorCode = ErrorCodes.DigitalWalletUninitialized
                errorMessage = "Apple Pay has not been initialized"
            } catch OPApplePayLauncherError.delegateNotSet {
                errorCode = ErrorCodes.DigitalWalletUninitialized
                errorMessage = "Apple Pay has not been initialized"
            } catch OPApplePayLauncherError.emptyMerchantId {
                errorCode = ErrorCodes.EmptyMerchantId
                errorMessage = "Merchant ID cannot be empty"
            } catch OPApplePayLauncherError.emptyCompanyLabel {
                errorCode = ErrorCodes.EmptyCompanyLabel
                errorMessage = "Company label cannot be empty"
            } catch OPApplePayLauncherError.invalidCountryCode {
                errorCode = ErrorCodes.InvalidCountryCode
                errorMessage = "Country code cannot be empty"
            } catch OPApplePayLauncherError.lineItemTotalMismatchError {
                errorCode = ErrorCodes.LineItemTotalMismatchError
                errorMessage = "The total of the line items does not match the total amount"
            } catch {
                errorCode = ErrorCodes.GeneralError
                errorMessage = "Unexpected error occurred"
            }

            let errorData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: "\(baseError): \(errorMessage)",
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterKey,
                DataKeys.DigitalWalletErrorCodeKey: errorCode
            ]
            
            result(errorData)
            self.applePayCleanup()
        }
    }
    
    public func paymentMethodCreated(from launcher: OPApplePayLauncherProtocol, with paymentMethod: OPPaymentMethodProtocol) -> NSError? {
        guard _applePayResult != nil else {
            os_log("Unexpected error: Saved method call resolver is nil", log: _logger)
            return OPError(errorType: .generalError, description: "Unexpected error: Saved method call resolver is nil")
        }

        _applePayPaymentMethod = paymentMethod

        // NOTE: This will trigger a success flow in the Apple Pay Sheet... If the actual order placement fails with the Olo Odering API it
        // will be up to the app developer to display a different error in their app to let the end user know that the Apple Pay flow did not
        // succeed. There is currenlty no way around this limitation.
        return nil
    }
    
    public func applePayDismissed(from launcher: OPApplePayLauncherProtocol, with status: OPApplePayStatus, error: Error?) {
        guard let applePayResult = _applePayResult else {
            // If there is no saved resolver there is nothing to be done except log the problem and return
            os_log("Unexpected error: Saved method call resolver is nil", log: _logger)
            applePayCleanup()
            return
        }

        // Nil data means the user canceled, so let's initialize to that, and update applePayData for all other
        // scenarios
        var applePayData: Dictionary<String, Any>? = nil

        if status == .error {
            var errorMessage = "An unexpected error occurred"
            if error != nil && error as? OPApplePayLauncherError != OPApplePayLauncherError.applePayNotSupported {
                errorMessage = error!.localizedDescription
            }
            
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: errorMessage,
                DataKeys.DigitalWalletErrorCodeKey: ErrorCodes.GeneralError,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentMethod == nil {
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: "Unexpected error: Payment method is nil",
                DataKeys.DigitalWalletErrorCodeKey: ErrorCodes.GeneralError,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentMethod != nil {
            applePayData = _applePayPaymentMethod!.toDictionary()
        }

        applePayCleanup()
        applePayResult(applePayData)
    }

    private func applePayCleanup() {
        _applePayPaymentMethod = nil
        _applePayResult = nil
        _applePaySemaphore.signal()
    }
    
    private func isSdkInitialized(result: @escaping FlutterResult) {
        result(sdkInitialized)
    }
    
    private func isDigitalWalletReady(result: @escaping FlutterResult) {
        result(applePayReady)
    }
    
    private func setSdkWrapperInfo(version: String, buildType: String) {
        let versionStrings = version.components(separatedBy: ".")
        let majorVersionString = versionStrings.count > MajorVersionIndex ? versionStrings[MajorVersionIndex] : "0"
        let minorVersionString = versionStrings.count > MinorVersionIndex ? versionStrings[MinorVersionIndex] : "0"
        let buildVersionString = versionStrings.count > BuildVersionIndex ? versionStrings[BuildVersionIndex] : "0"

        let sdkWrapperInfo = OPSdkWrapperInfo(
            withMajorVersion: Int(majorVersionString) ?? 0,
            withMinorVersion: Int(minorVersionString) ?? 0,
            withBuildVersion: Int(buildVersionString) ?? 0,
            withSdkBuildType: buildType == DataKeys.HybridBuildTypePublicValue ? .publicBuild : .internalBuild,
            withSdkPlatform: .flutter
        )

        OloPayAPI.sdkWrapperInfo = sdkWrapperInfo
    }
    
    private func emitDigitalWalletReadyEvent(_ previousState: Bool) {
        let newState = self.applePayReady
        
        // Filter out redundant emitting of this event if the actual state value hasn't changed, but only if it is not
        // the first time the event has been emitted
        if _hasEmittedDigitalWalletReadyEvent && newState == previousState {
            return
        }
        
        _hasEmittedDigitalWalletReadyEvent = true
        dispatchToMainThread {
            OloPaySdkPlugin._methodChannel?.invokeMethod(
                DataKeys.DigitalWalletReadyEventHandlerKey,
                arguments: [DataKeys.DigitalWalletReadyParameterKey: newState]
            )
        }
    }
    
    private func getLineItemsFromFlutterArgs(
        args: [String : Any],
        baseError: String,
        result: @escaping FlutterResult
    ) throws -> [PKPaymentSummaryItem]? {
        do {
            var lineItems: [PKPaymentSummaryItem]? = nil
            if let flutterLineItems: [Dictionary<String, Any?>] = try args.getOrErrorResult(
                for: DataKeys.LineItemsKey,
                withDefault: nil,
                baseError: baseError,
                result: result
            ), !flutterLineItems.isEmpty {
                lineItems = []
                try flutterLineItems.forEach { item in
                    lineItems!.append(
                        PKPaymentSummaryItem(
                            label: try item.getStringOrErrorResult(
                                for: DataKeys.LineItemLabelKey,
                                baseError: baseError,
                                acceptEmptyValue: false,
                                result: result
                            ),
                            amount: NSDecimalNumber(
                                decimal: Decimal(
                                    try item.getOrErrorResult(
                                        for: DataKeys.LineItemAmountKey,
                                        baseError: baseError,
                                        result: result
                                    ) as Double
                                )
                            ),
                            type: try item.getStringOrErrorResult(
                                for: DataKeys.LineItemStatusKey,
                                withDefault: DataKeys.LineItemFinalStatusKey,
                                baseError: baseError,
                                acceptEmptyValue: true,
                                result: result
                            ) == DataKeys.LineItemFinalStatusKey ? .final : .pending
                        )
                    )
                }
            }
            return lineItems
        } catch let error {
            throw error
        }
    }
    
    // Default values
    private static let defaultProductionEnvironment = true
    private static let defaultCountryCode = "US"
    private static let defaultCurrencyCode = OPCurrencyCode.usd
    private static let defaultFullBillingAddressRequired = false
    private static let defaultPhoneNumberRequired = false
    private static let defaultFullNameRequired = false
    private static let defaultEmailRequired = false
    private let MajorVersionIndex = 0
    private let MinorVersionIndex = 1
    private let BuildVersionIndex = 2
    private let defaultVersionString = "0.0.0"
}
