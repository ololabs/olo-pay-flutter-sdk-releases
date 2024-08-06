// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.data

class DataKeys {
    companion object {
        // Prefix Keys
        private const val BridgePrefix = "com.olo.flutter.olo_pay_sdk"
        private const val SingleLineViewType = "PaymentCardDetailsSingleLineView"
        private const val CvvViewType = "PaymentCardCvvView"

        // Method Channel Keys
        const val OloPaySdkMethodChannelKey = "$BridgePrefix/sdk"
        const val SingleLineBaseMethodChannelKey = "$BridgePrefix/$SingleLineViewType:"
        const val CvvBaseMethodChannelKey = "$BridgePrefix/$CvvViewType:"

        // View Registration Keys
        const val PaymentCardDetailsSingleLineViewKey = "$BridgePrefix/$SingleLineViewType"
        const val PaymentCardCvvViewKey = "$BridgePrefix/$CvvViewType"

        // Method Call Keys
        const val InitializeOloPayMethodKey = "initialize"
        const val InitializeMetadataMethodKey = "initializeMetadata"
        const val InitializeGooglePayMethodKey = "initializeGooglePay"
        const val ChangeGooglePayVendorMethodKey = "changeGooglePayVendor"
        const val IsDigitalWalletReadyMethodKey = "isDigitalWalletReady"
        const val CreateDigitalWalletPaymentMethod = "createDigitalWalletPaymentMethod"
        const val IsInitializedMethodKey = "isInitialized"
        const val CreatePaymentMethodKey = "createPaymentMethod"
        const val CreateCvvUpdateTokenKey = "createCvvUpdateToken"
        const val GetStateMethodKey = "getState"
        const val IsValidMethodKey = "isValid"
        const val GetCardTypeMethodKey = "getCardType"
        const val SetEnabledMethodKey = "setEnabled"
        const val IsEnabledMethodKey = "isEnabled"
        const val HasErrorMessageMethodKey = "hasErrorMessage"
        const val GetErrorMessageMethodKey = "getErrorMessage"
        const val ClearFieldsMethodKey = "clearFields"
        const val RequestFocusMethodKey = "requestFocus"
        const val ClearFocusMethodKey = "clearFocus"
        const val RefreshUiMethod = "refreshUI"

        // Method Call Parameter Keys
        const val EnabledParameterKey = "enabled"
        const val IgnoreUneditedFieldsParameterKey = "ignoreUneditedFields"
        const val DigitalWalletAmountParameterKey = "amount"
        const val DigitalWalletCountryCodeParameterKey = "countryCode"
        const val DigitalWalletErrorMessageParameterKey = "errorMessage"
        const val GPayErrorTypeParameterKey = "googlePayErrorType"
        const val DigitalWalletTypeParameterKey = "digitalWalletType"
        const val DigitalWalletTypeParameterValue = "googlePay"
        const val DigitalWalletReadyParameterKey = "isReady"
        const val CreationParameters = "creationParams"

        // SDK Initialization Keys
        const val ProductionEnvironmentKey = "productionEnvironment"
        const val HybridSdkVersionKey = "version"
        const val HybridBuildTypeKey = "buildType"
        const val HybridBuildTypePublicValue = "public"
        const val HybridBuildTypeInternalValue = "internal"

        // Google Pay Initialization Keys
        const val GPayProductionEnvironmentKey = "googlePayProductionEnvironment"
        const val GPayExistingPaymentMethodRequiredKey = "existingPaymentMethodRequired"
        const val GPayEmailRequiredKey = "emailRequired"
        const val GPayPhoneNumberRequiredKey = "phoneNumberRequired"
        const val GPayFullAddressFormatKey = "fullAddressFormat"
        const val GPayMerchantNameKey = "merchantName"

        // Payment Method Keys
        const val PaymentMethodKey = "paymentMethod"
        const val IDKey = "id"
        const val Last4Key = "last4"
        const val CardTypeKey = "cardType"
        const val ExpirationMonthKey = "expMonth"
        const val ExpirationYearKey = "expYear"
        const val PostalCodeKey = "postalCode"
        const val CountryCodeKey = "countryCode"
        const val IsDigitalWalletKey = "isDigitalWallet"

        // Digital Wallet Payment Method Request Keys
        const val GPayCurrencyCodeKey = "currencyCode"
        const val GPayCurrencyMultiplierKey = "currencyMultiplier"

        // Event Handler Keys
        const val OnFocusChangedEventHandlerKey = "onFocusChanged"
        const val OnInputChangedEventHandlerKey = "onInputChanged"
        const val OnValidStateChangedEventHandlerKey = "onValidStateChanged"
        const val OnErrorMessageChangedEventHandlerKey = "onErrorMessageChanged"
        const val DigitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent"

        // EventHandler Parameter Keys
        const val FocusedFieldParameterKey = "focusedField"
        const val FieldStatesParameterKey = "fieldStates"

        //ICardFieldState Keys
        const val IsValidKey = "isValid"
        const val IsFocusedKey = "isFocused"
        const val IsEmptyKey = "isEmpty"
        const val WasEditedKey = "wasEdited"
        const val WasFocusedKey = "wasFocused"

        // Text Styles Keys
        const val TextColorKey = "textColor"
        const val ErrorTextColorKey = "errorTextColor"
        const val CursorColorKey = "cursorColor"
        const val HintTextColorKey = "hintTextColor"
        const val TextSizeKey = "textSize"
        const val FontAssetKey = "fontAsset"

        // Background Style Keys
        const val BackgroundColorKey = "backgroundColor"
        const val BorderColorKey = "borderColor"
        const val BorderWidthKey = "borderWidth"
        const val BorderRadiusKey = "borderRadius"
        
        // Padding Style Keys
        const val StartPaddingKey = "startPadding"
        const val EndPaddingKey = "endPadding"
        const val TopPaddingKey = "topPadding"
        const val BottomPaddingKey = "bottomPadding"

        // View Initializer Argument Keys
        const val HintsArgumentKey = "hints"
        const val TextStylesArgumentsKey = "textStyles"
        const val BackgroundStylesArgumentsKey = "backgroundStyles"
        const val PaddingStylesArgumentsKey = "paddingStyles"
        const val CustomErrorMessagesArgumentsKey = "customErrorMessages"
        const val TextAlignmentKey = "textAlignment"

        // Error Types
        const val EmptyErrorKey = "emptyError"
        const val InvalidErrorKey = "invalidError"

        // Custom Error Message Keys
        const val UnsupportedCardErrorKey = "unsupportedCardError"

        // Gravity Keys
        const val GravityCenterKey = "center"
        const val GravityRightKey = "right"
    }
}