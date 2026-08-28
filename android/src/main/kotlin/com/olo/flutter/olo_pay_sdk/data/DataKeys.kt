// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.data

class DataKeys {
    companion object {
        // Prefix Keys
        private const val BridgePrefix = "com.olo.flutter.olo_pay_sdk"
        private const val SingleLineViewType = "PaymentCardDetailsSingleLineView"
        private const val CvvViewType = "PaymentCardCvvView"
        private const val FormViewType = "PaymentCardDetailsFormView"
        private const val DigitalWalletButtonViewType = "DigitalWalletButton"

        // Method Channel Keys
        const val OloPaySdkMethodChannelKey = "$BridgePrefix/sdk"
        const val SingleLineBaseMethodChannelKey = "$BridgePrefix/$SingleLineViewType:"
        const val CvvBaseMethodChannelKey = "$BridgePrefix/$CvvViewType:"
        const val PaymentCardDetailsFormBaseMethodChannelKey = "$BridgePrefix/$FormViewType:"
        const val DigitalWalletButtonBaseMethodChannelKey = "$BridgePrefix/$DigitalWalletButtonViewType:"

        // View Registration Keys
        const val PaymentCardDetailsSingleLineViewKey = "$BridgePrefix/$SingleLineViewType"
        const val PaymentCardCvvViewKey = "$BridgePrefix/$CvvViewType"
        const val PaymentCardDetailsFormViewKey = "$BridgePrefix/$FormViewType"
        const val DigitalWalletButtonViewKey = "$BridgePrefix/$DigitalWalletButtonViewType"

        // Method Call Keys
        const val InitializeOloPayMethodKey = "initialize"
        const val InitializeMetadataMethodKey = "initializeMetadata"
        const val InitializeDigitalWalletMethodKey = "initializeDigitalWallet"
        const val UpdateDigitalWalletConfigurationMethodKey = "updateDigitalWalletConfiguration"
        const val IsDigitalWalletReadyMethodKey = "isDigitalWalletReady"
        const val CreateDigitalWalletPaymentMethod = "createDigitalWalletPaymentMethod"
        const val IsInitializedMethodKey = "isInitialized"
        const val CreatePaymentMethodKey = "createPaymentMethod"
        const val CreateCvvUpdateTokenKey = "createCvvUpdateToken"
        const val GetStateMethodKey = "getState"
        const val IsValidMethodKey = "isValid"
        const val GetCardTypeMethodKey = "getCardType"
        const val IsEnabledMethodKey = "isEnabled"
        const val HasErrorMessageMethodKey = "hasErrorMessage"
        const val GetErrorMessageMethodKey = "getErrorMessage"
        const val ClearFieldsMethodKey = "clearFields"
        const val RequestFocusMethodKey = "requestFocus"
        const val ClearFocusMethodKey = "clearFocus"
        const val RefreshUiMethod = "refreshUI"

        // Method Call Parameter Keys
        const val DarkModeParameterKey = "darkMode"
        const val EnabledParameterKey = "enabled"
        const val IgnoreUneditedFieldsParameterKey = "ignoreUneditedFields"
        const val DigitalWalletAmountParameterKey = "amount"
        const val DigitalWalletCountryCodeParameterKey = "countryCode"
        const val DigitalWalletErrorMessageParameterKey = "errorMessage"
        const val DigitalWalletErrorCode = "digitalWalletErrorCode"
        const val DigitalWalletTypeParameterKey = "digitalWalletType"
        const val DigitalWalletTypeParameterValue = "googlePay"
        const val DigitalWalletReadyParameterKey = "isReady"
        const val CreationParameters = "creationParams"
        const val FocusFieldParameterKey = "focusField"

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
        const val GPayFullNameRequiredKey = "fullNameRequired"
        const val GPayMerchantNameKey = "companyLabel"
        const val GPayFullBillingAddressRequiredKey = "fullBillingAddressRequired"
        const val GPayCurrencyCodeKey = "currencyCode"
        const val GPayCheckoutStatusKey = "googlePayCheckoutStatus"
        const val GPayTotalPriceLabelKey = "totalPriceLabel"
        const val GPayLineItemsKey = "lineItems"
        const val GPayValidateLineItems = "validateLineItems"

        // Payment Method Keys
        const val PaymentMethodKey = "paymentMethod"
        const val IDKey = "id"
        const val Last4Key = "last4"
        const val CardTypeKey = "cardType"
        const val ExpirationMonthKey = "expMonth"
        const val ExpirationYearKey = "expYear"
        const val PostalCodeKey = "postalCode"
        const val CountryCodeKey = "countryCode"
        const val EmailKey = "email"
        const val DigitalWalletCardDescriptionKey = "digitalWalletCardDescription"
        const val BillingAddressKey = "billingAddress"
        const val FullNameKey = "fullName"
        const val PhoneNumberKey = "phoneNumber"
        const val IsDigitalWalletKey = "isDigitalWallet"

        // Address Keys
        const val Address1Key = "address1"
        const val Address2Key = "address2"
        const val Address3Key = "address3"
        const val LocalityKey = "locality"
        const val AdministrativeAreaKey = "administrativeArea"
        const val SortingCodeKey = "sortingCode"

        // Digital Wallet Payment Method Request Keys
        const val GPayCurrencyMultiplierKey = "currencyMultiplier"

        // Card field values (Matches with Android enums)
        const val CardNumberFieldValueKey = "CardNumber"
        const val ExpirationFieldValueKey = "Expiration"
        const val CvvFieldValueKey = "Cvv"
        const val PostalCodeFieldValueKey = "PostalCode"

        // Event Handler Keys
        const val OnFocusChangedEventHandlerKey = "onFocusChanged"
        const val OnInputChangedEventHandlerKey = "onInputChanged"
        const val OnValidStateChangedEventHandlerKey = "onValidStateChanged"
        const val OnErrorMessageChangedEventHandlerKey = "onErrorMessageChanged"
        const val DigitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent"
        const val DigitalWalletButtonClickedEventHandlerKey = "digitalWalletButtonClickedEvent"

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
        const val FocusedHintTextColorKey = "focusedHintTextColor"
        const val TextSizeKey = "textSize"
        const val ErrorTextSizeKey = "errorTextSize"
        const val FontAssetKey = "fontAsset"
        const val ErrorFontAssetKey = "errorFontAsset"

        // Background Style Keys
        const val BackgroundColorKey = "backgroundColor"
        const val BorderColorKey = "borderColor"
        const val BorderWidthKey = "borderWidth"
        const val BorderRadiusKey = "borderRadius"

        // Field Divider Style Keys
        const val FieldDividerColorKey = "dividerColor"
        const val FieldDividerWidthKey = "dividerWidth"
        
        // Padding Style Keys
        const val StartPaddingKey = "startPadding"
        const val EndPaddingKey = "endPadding"
        const val TopPaddingKey = "topPadding"
        const val BottomPaddingKey = "bottomPadding"

        // View Initializer Argument Keys
        const val HintsArgumentKey = "hints"
        const val FocusedFieldHintsArgumentKey = "focusedFieldHints"
        const val TextStylesArgumentsKey = "textStyles"
        const val BackgroundStylesArgumentsKey = "backgroundStyles"
        const val FieldDividerStylesArgumentsKey = "fieldDividerStyles"
        const val ErrorBackgroundStylesArgumentsKey = "errorBackgroundStyles"
        const val PaddingStylesArgumentsKey = "paddingStyles"
        const val ErrorPaddingStylesArgumentsKey = "errorPaddingStyles"
        const val CustomErrorMessagesArgumentsKey = "customErrorMessages"
        const val TextAlignmentKey = "textAlignment"
        const val ErrorTextAlignmentKey = "errorTextAlignment"
        const val VerticalSpacingKey = "verticalSpacing"

        // Error Types
        const val EmptyErrorKey = "emptyError"
        const val InvalidErrorKey = "invalidError"

        // Custom Error Message Keys
        const val UnsupportedCardErrorKey = "unsupportedCardError"

        // Gravity Keys
        const val GravityCenterKey = "center"
        const val GravityRightKey = "right"

        // Google Pay Button Configuration Keys
        const val GooglePayButtonThemeKey = "GooglePayButtonTheme"
        const val GooglePayButtonTypeKey = "GooglePayButtonType"
        const val GooglePayButtonCornerRadiusKey = "GooglePayButtonCornerRadius"
        const val GooglePayButtonThemeDark = "dark"
        const val GooglePayButtonTypeCheckout = "checkout"

        // Line Item Keys
        const val LineItemAmountKey = "lineItemAmount"
        const val LineItemLabelKey = "lineItemLabel"
        const val LineItemTypeKey = "lineItemType"
        const val LineItemStatusKey = "lineItemStatus"
    }
}