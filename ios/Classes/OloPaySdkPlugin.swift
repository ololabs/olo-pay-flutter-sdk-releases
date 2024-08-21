// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import Flutter
import UIKit
import os
import os.log

import OloPaySDK

public class OloPaySdkPlugin: NSObject, FlutterPlugin, OPApplePayContextDelegate {
    private let _logger = OSLog.init(subsystem: Bundle.main.bundleIdentifier!, category: DataKeys.BridgePrefix)
    
    private let _sdkInitializingSemaphore = DispatchSemaphore(value: 1)
    private let _sdkInitializedSemaphore = DispatchSemaphore(value: 1)
    private let _applePaySemaphore = DispatchSemaphore(value: 1)
    
    private var _applePayContext: OPApplePayContext? = nil
    private var _applePayPaymentMethod: OloPaySDK.OPPaymentMethodProtocol? = nil
    private var _initializeMetadataCalled = false
    
    private static var _methodChannel: FlutterMethodChannel? = nil

    //NOTE: Not private for testing purposes
    internal var _applePayResult: FlutterResult? = nil
    
    // WARNING: NEVER ACCESS/MODIFY THIS VARIABLE DIRECTLY. USE THREAD-SAFE GETTERS AND SETTERS
    private var _sdkInitialized = false

    var sdkInitialized: Bool {
        get {
            self._sdkInitializedSemaphore.wait()
            let value = _sdkInitialized
            self._sdkInitializedSemaphore.signal()
            return value
        }
        set(newValue) {
            self._sdkInitializedSemaphore.wait()
            _sdkInitialized = newValue
            self._sdkInitializedSemaphore.signal()
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
            PaymentCardCvvViewFactory(messenger: messenger),
            withId: DataKeys.PaymentCardCvvViewKey
        )
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case DataKeys.InitializeMethodKey:
            initializeOloPay(call: call, result: result)
        case DataKeys.InitializeMetadataMethodKey:
            initializeMetadata(call: call, result: result)
        case DataKeys.IsInitializedMethodKey:
            isInitialized(result: result)
        case DataKeys.IsDigitalWalletReadyMethodKey:
            isApplePayReady(result: result)
        case DataKeys.CreateDigitalWalletPaymentMethod:
            getDigitalWalletPaymentMethod(call: call, result: result)
        case DataKeys.GetFontNamesMethodKey:
            getFontNamesForAssets(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeOloPay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, Any>
        
        DispatchQueue.global(qos: .background).async {
            self._sdkInitializingSemaphore.wait()

            self.sdkInitialized = false

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
                    return
                }
            }
            
            var merchantId: String? = nil
            var companyLabel: String? = nil
            let applePayArgs = args?.getDictionary(DataKeys.ApplePaySetupArgsKey)
            
            if let applePayArgs = applePayArgs {
                let baseError = "Unable to initialize Apple Pay"
                
                do {
                    merchantId = try applePayArgs.getStringOrErrorResult(
                        for: DataKeys.ApplePayMerchantIdParameterKey,
                        baseError: baseError,
                        acceptEmptyValue: false,
                        result: result
                    )
                } catch {
                    return
                }
                
                do {
                    companyLabel = try applePayArgs.getStringOrErrorResult(
                        for: DataKeys.ApplePayCompanyLabelParameterKey,
                        baseError: baseError,
                        acceptEmptyValue: false,
                        result: result
                    )
                } catch {
                    return
                }
            }
            
            let setupParameters = OPSetupParameters(
                withEnvironment: productionEnvironment ? .production : .test,
                withApplePayMerchantId: merchantId,
                withApplePayCompanyLabel: companyLabel
            )

            OloPayApiInitializer().setup(with: setupParameters) {
                self.sdkInitialized = true
                self._sdkInitializingSemaphore.signal()
                result(nil)
                
                if applePayArgs != nil {
                    dispatchToMainThreadIfNecessary {
                        OloPaySdkPlugin._methodChannel?.invokeMethod(
                            DataKeys.DigitalWalletReadyEventHandlerKey,
                            arguments: [DataKeys.DigitalWalletReadyParameterKey: OloPayAPI().deviceSupportsApplePay()]
                        )
                    }
                }
            }
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
    
    private func getDigitalWalletPaymentMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
        
        var amountDouble: Double = 0.0
        do {
            amountDouble = try args.getOrErrorResult(
                for: DataKeys.DigitalWalletAmountParameterKey,
                baseError: baseError,
                result: result)
        } catch {
            return
        }
        
        guard amountDouble >= 0 else {
            let error = "\(baseError): \(DataKeys.DigitalWalletAmountParameterKey) cannot be negative"
            result(FlutterError(code: ErrorCodes.InvalidParameter, message: error, details: nil))
            return
        }
        
        var countryCode = self.defaultCountryCode
        do {
            countryCode = try args.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCountryCodeParameterKey,
                withDefault: self.defaultCountryCode,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result)
        } catch {
            return
        }
        
        var currencyCode = self.defaultCurrencyCode
        do {
            currencyCode = try args.getStringOrErrorResult(
                for: DataKeys.DigitalWalletCurrencyCodeParameterKey,
                withDefault: self.defaultCurrencyCode,
                baseError: baseError,
                acceptEmptyValue: false,
                result: result)
        } catch {
            return
        }
        
        // NOTE: This deviceSupportsApplePay() check is moved here so we can
        //       test the logic around parameters passed into this call.
        //       We cannot write unit tests for anything beyond this point.
        let oloPayApi = OloPayAPI()
        guard oloPayApi.deviceSupportsApplePay() else {
            let error = "\(baseError): Apple Pay is not supported on this device"
            result(FlutterError(code: ErrorCodes.ApplePayUnsupported, message: error, details: nil))
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self._applePaySemaphore.wait()

            let amount = NSDecimalNumber(decimal: Decimal(amountDouble))
            
            var errorMessage: String

            do {
                let paymentRequest = try oloPayApi.createPaymentRequest(forAmount: amount, inCountry: countryCode, withCurrency: currencyCode)
                guard let applePayContext = OPApplePayContext(paymentRequest: paymentRequest, delegate: self) else {
                    result(FlutterError(code: ErrorCodes.GeneralError, message: "Unexpected Error: Apple Pay Context is nil", details: nil))
                    return
                }
                self._applePayContext = applePayContext
                try self._applePayContext!.presentApplePay()
                self._applePayResult = result
                return
            } catch  {
                errorMessage = error.localizedDescription
            }

            let errorData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: errorMessage,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]

            self.applePayCleanup()
            result(errorData)
        }
    }
    
    public func applePaymentMethodCreated(_ context: OloPaySDK.OPApplePayContextProtocol, didCreatePaymentMethod paymentMethod: OloPaySDK.OPPaymentMethodProtocol) -> NSError? {
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
    
    public func applePaymentCompleted(_ context: OPApplePayContextProtocol, didCompleteWith status: OPPaymentStatus, error: Error?) {
        guard let applePayResult = _applePayResult else {
            // If there is no saved resolver there is nothing to be done except log the problem and return
            os_log("Unexpected error: Saved method call resolver is nil", log: _logger)
            applePayCleanup()
            return
        }

        var applePayData: Dictionary<String, Any>? = nil

        if status == .error {
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: error!.localizedDescription,
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentMethod == nil {
            applePayData = [
                DataKeys.DigitalWalletErrorMessageParameterKey: "Unexpected error: Payment method is nil",
                DataKeys.DigitalWalletTypeParameterKey: DataKeys.DigitalWalletTypeParameterValue
            ]
        } else if status == .success && _applePayPaymentMethod != nil {
            applePayData = _applePayPaymentMethod!.toDictionary()
        }

        applePayCleanup()
        applePayResult(applePayData)
    }

    private func applePayCleanup() {
        _applePayContext = nil
        _applePayPaymentMethod = nil
        _applePayResult = nil
        _applePaySemaphore.signal()
    }
    
    private func isInitialized(result: @escaping FlutterResult) {
        result(self.sdkInitialized)
    }
    
    private func isApplePayReady(result: @escaping FlutterResult) {
        result(sdkInitialized && OloPayAPI().deviceSupportsApplePay())
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
    
    // Default values
    private static let defaultProductionEnvironment = true
    private let defaultCountryCode = "US"
    private let defaultCurrencyCode = "USD"
    private let MajorVersionIndex = 0
    private let MinorVersionIndex = 1
    private let BuildVersionIndex = 2
    private let defaultVersionString = "0.0.0"
}
