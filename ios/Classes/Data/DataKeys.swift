// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
//
//  File.swift
//  olo_pay_sdk
//
//  Created by Justin Anderson on 12/6/23.
//

import Foundation

public class DataKeys {
    // Prefix Keys
    public static let BridgePrefix = "com.olo.flutter.olo_pay_sdk"
    public static let SingleLineViewType = "PaymentCardDetailsSingleLineView"
    public static let CvvViewType = "PaymentCardCvvView"
    
    // Method Channel Keys
    public static let OloPaySdkMethodChannelKey = "\(BridgePrefix)/sdk"
    public static let SingleLineBaseMethodChannelKey = "\(BridgePrefix)/\(SingleLineViewType):"
    public static let CvvBaseMethodChannelKey = "\(BridgePrefix)/\(CvvViewType):"
    
    // View Registration Keys
    public static let PaymentCardDetailsSingleLineViewKey = "\(BridgePrefix)/\(SingleLineViewType)"
    public static let PaymentCardCvvViewKey = "\(BridgePrefix)/\(CvvViewType)"
    
    // Method Call Keys
    public static let InitializeMethodKey = "initialize"
    public static let InitializeMetadataMethodKey = "initializeMetadata"
    public static let IsInitializedMethodKey = "isInitialized"
    public static let IsDigitalWalletReadyMethodKey = "isDigitalWalletReady"
    public static let CreatePaymentMethodKey = "createPaymentMethod"
    public static let CreateCvvTokenMethodKey = "createCvvUpdateToken"
    public static let CreateDigitalWalletPaymentMethod = "createDigitalWalletPaymentMethod"
    public static let GetStateMethodKey = "getState"
    public static let IsValidMethodKey = "isValid"
    public static let GetCardTypeMethodKey = "getCardType"
    public static let SetEnabledMethodKey = "setEnabled"
    public static let IsEnabledMethodKey = "isEnabled"
    public static let HasErrorMessageMethodKey = "hasErrorMessage"
    public static let GetErrorMessageMethodKey = "getErrorMessage"
    public static let ClearFieldsMethodKey = "clearFields"
    public static let RequestFocusMethodKey = "requestFocus"
    public static let ClearFocusMethodKey = "clearFocus"
    public static let RefreshUiMethodKey = "refreshUI"
    public static let GetFontNamesMethodKey = "getFontNames"

    // Method Call Parameter Keys
    public static let EnabledParameterKey = "enabled"
    public static let IgnoreUneditedFieldsParameterKey = "ignoreUneditedFields"
    public static let DigitalWalletAmountParameterKey = "amount"
    public static let DigitalWalletCountryCodeParameterKey = "countryCode"
    public static let DigitalWalletCurrencyCodeParameterKey = "currencyCode"
    public static let DigitalWalletErrorMessageParameterKey = "errorMessage"
    public static let DigitalWalletTypeParameterKey = "digitalWalletType"
    public static let DigitalWalletTypeParameterValue = "applePay"
    public static let ApplePayMerchantIdParameterKey = "merchantId"
    public static let ApplePayCompanyLabelParameterKey = "companyLabel"
    public static let DigitalWalletReadyParameterKey = "isReady"
    public static let CreationParameters = "creationParams"
    
    // SDK Initialization Keys
    public static let ProductionEnvironmentKey = "productionEnvironment"
    public static let ApplePaySetupArgsKey = "applePaySetup"
    public static let HybridSdkVersionKey = "version"
    public static let HybridBuildTypeKey = "buildType"
    public static let HybridBuildTypePublicValue = "public"
    public static let HybridBuildTypeInternalValue = "internal"
    
    // Payment Method Keys
    public static let IDKey = "id"
    public static let Last4Key = "last4"
    public static let CardTypeKey = "cardType"
    public static let ExpirationMonthKey = "expMonth"
    public static let ExpirationYearKey = "expYear"
    public static let PostalCodeKey = "postalCode"
    public static let CountryCodeKey = "countryCode"
    public static let IsDigitalWalletKey = "isDigitalWallet"
    
    // Event Handler Keys
    public static let OnFocusChangedEventHandlerKey = "onFocusChanged"
    public static let OnInputChangedEventHandlerKey = "onInputChanged"
    public static let OnValidStateChangedEventHandlerKey = "onValidStateChanged"
    public static let OnErrorMessageChangedEventHandlerKey = "onErrorMessageChanged"
    public static let DigitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent"

    // EventHandler Parameter Keys
    public static let FocusedFieldParameterKey = "focusedField"
    public static let FieldStatesParameterKey = "fieldStates"

    // OPCardFieldStateProtocol Keys
    public static let IsValidKey = "isValid"
    public static let IsFocusedKey = "isFocused"
    public static let IsEmptyKey = "isEmpty"
    public static let WasEditedKey = "wasEdited"
    public static let WasFocusedKey = "wasFocused"
    
    // Card field values (Matches with Android enums)
    public static let CardNumberFieldValueKey = "CardNumber"
    public static let ExpirationFieldValueKey = "Expiration"
    public static let CvvFieldValueKey = "Cvv"
    public static let PostalCodeFieldValueKey = "PostalCode"
    
    // Text Style Keys
    public static let TextColorKey = "textColor"
    public static let ErrorTextColorKey = "errorTextColor"
    public static let CursorColorKey = "cursorColor"
    public static let HintTextColorKey = "hintTextColor"
    public static let TextSizeKey = "textSize"
    public static let FontAssetKey = "fontAsset"
    public static let FontNameKey = "fontName"
    public static let FontAssetListKey = "fontAssetList"

    // Background Style Keys
    public static let BackgroundColorKey = "backgroundColor"
    public static let BorderColorKey = "borderColor"
    public static let BorderWidthKey = "borderWidth"
    public static let BorderRadiusKey = "borderRadius"
    
    // Padding Style Keys
    public static let StartPaddingKey = "startPadding"
    public static let EndPaddingKey = "endPadding"
    public static let TopPaddingKey = "topPadding"
    public static let BottomPaddingKey = "bottomPadding"
    
    // View Initializer Argument Keys
    public static let HintsArgumentsKey = "hints"
    public static let TextStylesArgumentsKey = "textStyles"
    public static let BackgroundStylesArgumentsKey = "backgroundStyles"
    public static let PaddingStylesArgumentsKey = "paddingStyles"
    public static let CustomErrorMessagesArgumentsKey = "customErrorMessages"
    public static let TextAlignmentKey = "textAlignment"
    
    // Error Types
    public static let emptyErrorKey = "emptyError"
    public static let invalidErrorKey = "invalidError"
    
    // Custom Error Message Keys
    public static let unsupportedCardErrorKey = "unsupportedCardError"
    
    // Alignment keys
    public static let AlignmentCenterKey = "center"
    public static let AlignmentRightKey = "right"
}
