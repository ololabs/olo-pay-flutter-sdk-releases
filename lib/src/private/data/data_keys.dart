// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/cupertino.dart';

/// @nodoc
@protected
class DataKeys {
  // Prefix Keys
  static const bridgePrefix = "com.olo.flutter.olo_pay_sdk";
  static const cvvViewType = "PaymentCardCvvView";
  static const singleLineViewType = "PaymentCardDetailsSingleLineView";
  static const formViewType = "PaymentCardDetailsFormView";
  static const digitalWalletButtonViewType = "DigitalWalletButton";

  // View Registration Keys
  static const cvvViewTypeKey = '$bridgePrefix/$cvvViewType';
  static const singleLineViewTypeKey = '$bridgePrefix/$singleLineViewType';
  static const formViewTypeKey = '$bridgePrefix/$formViewType';
  static const digitalWalletButtonViewTypeKey =
      '$bridgePrefix/$digitalWalletButtonViewType';

  // Method Channel Keys
  static const oloPaySdkMethodChannelKey = '$bridgePrefix/sdk';
  static const cvvBaseMethodChannelKey = '$cvvViewTypeKey:';
  static const singleLineBaseMethodChannelKey = '$singleLineViewTypeKey:';
  static const formBaseMethodChannelKey = '$formViewTypeKey:';
  static const digitalWalletButtonBaseMethodChannelKey =
      '$digitalWalletButtonViewTypeKey:';

  // Native Method Keys
  static const initializeMethodKey = "initialize";
  static const initializeMetadataKey = "initializeMetadata";
  static const initializeDigitalWalletMethodKey = "initializeDigitalWallet";
  static const updateDigitalWalletConfigurationMethodKey =
      "updateDigitalWalletConfiguration";
  static const isInitializedMethodKey = "isInitialized";
  static const isDigitalWalletReadyMethodKey = "isDigitalWalletReady";
  static const createPaymentMethodKey = "createPaymentMethod";
  static const createCvvUpdateToken = "createCvvUpdateToken";
  static const createDigitalWalletPaymentMethodKey =
      "createDigitalWalletPaymentMethod";
  static const getStateMethodKey = "getState";
  static const isValidMethodKey = "isValid";
  static const getCardTypeMethodKey = "getCardType";
  static const isEnabledMethodKey = "isEnabled";
  static const hasErrorMessageMethodKey = "hasErrorMessage";
  static const getErrorMessageMethodKey = "getErrorMessage";
  static const clearFieldsMethodKey = "clearFields";
  static const requestFocusMethodKey = "requestFocus";
  static const clearFocusMethodKey = "clearFocus";
  static const refreshUiMethod = "refreshUI";
  static const getFontNamesMethodKey = "getFontNames";

  // Native Method Parameter Keys
  static const darkModeParameterKey = "darkMode";
  static const enabledParameterKey = "enabled";
  static const ignoreUneditedFieldsParameterKey = "ignoreUneditedFields";
  static const digitalWalletAmountParameterKey = "amount";
  static const digitalWalletCurrencyCodeKey = "currencyCode";
  static const digitalWalletTotalPriceLabelKey = "totalPriceLabel";
  static const digitalWalletLineItemsKey = "lineItems";
  static const digitalWalletsValidateLineItemsKey = "validateLineItems";
  static const googlePayCheckoutStatusKey = "googlePayCheckoutStatus";
  static const googlePayCurrencyMultiplierKey = "currencyMultiplier";
  static const applePayMerchantIdParameterKey = "merchantId";
  static const applePayFullPhoneticNameRequiredParameterKey =
      "fullPhoneticNameRequired";
  static const focusFieldParameterKey = "focusField";
  static const digitalWalletCompanyLabelParameterKey = "companyLabel";
  static const digitalWalletCountryCodeParameterKey = "countryCode";
  static const googlePayProductionEnvironmentParameterKey =
      "googlePayProductionEnvironment";
  static const googlePayFullBillingAddressRequiredParameterKey =
      "fullBillingAddressRequired";
  static const googlePayExistingPaymentMethodRequiredParameterKey =
      "existingPaymentMethodRequired";
  static const googlePayFullNameRequiredParameterKey = "fullNameRequired";
  static const googlePayEmailRequiredParameterKey = "emailRequired";
  static const googlePayPhoneNumberRequiredParameterKey = "phoneNumberRequired";
  static const digitalWalletReadyParameterKey = "isReady";
  static const digitalWalletErrorMessageParameterKey = "errorMessage";
  static const digitalWalletTypeParameterKey = "digitalWalletType";
  static const googlePayErrorTypeParameterKey = "googlePayErrorType";
  static const creationParameters = "creationParams";
  static const fontAssetListKey = "fontAssetList";

  // Initialize Olo Pay Options Keys
  static const productionEnvironmentKey = "productionEnvironment";
  static const freshInstallKey = "freshInstall";
  static const applePaySetupArgsKey = "applePaySetup";
  static const version = "version";
  static const buildType = "buildType";

  // Payment Method Keys
  static const pmIdKey = "id";
  static const pmLast4Key = "last4";
  static const pmCardTypeKey = "cardType";
  static const pmExpirationMonthKey = "expMonth";
  static const pmExpirationYearKey = "expYear";
  static const pmPostalCodeKey = "postalCode";
  static const pmCountryCodeKey = "countryCode";
  static const pmDigitalWalletCardDescriptionKey =
      "digitalWalletCardDescription";
  static const pmEmailKey = "email";
  static const pmPhoneNumberKey = "phoneNumber";
  static const pmFullNameKey = "fullName";
  static const pmFullPhoneticNameKey = "fullPhoneticName";
  static const pmBillingAddressKey = "billingAddress";
  static const pmIsDigitalWalletKey = "isDigitalWallet";

  // Address keys
  static const address1Key = "address1";
  static const address2Key = "address2";
  static const address3Key = "address3";
  static const localityKey = "locality";
  static const administrativeAreaKey = "administrativeArea";

  // Cvv Update Token Keys
  static const cvvIdKey = "id";

  // Event Handler Keys
  static const onFocusChangedEventHandlerKey = "onFocusChanged";
  static const onInputChangedEventHandlerKey = "onInputChanged";
  static const onValidStateChangedEventHandlerKey = "onValidStateChanged";
  static const onErrorMessageChangedEventHandlerKey = "onErrorMessageChanged";
  static const digitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent";
  static const digitalWalletButtonClickedEventHandlerKey =
      "digitalWalletButtonClickedEvent";

  // EventHandler Parameter Keys
  static const focusedFieldParameterKey = "focusedField";
  static const fieldStatesParameterKey = "fieldStates";

  // CardFieldState Keys
  static const isValidKey = "isValid";
  static const isFocusedKey = "isFocused";
  static const isEmptyKey = "isEmpty";
  static const wasEditedKey = "wasEdited";
  static const wasFocusedKey = "wasFocused";

  // Card field values (Matches with Android enums)
  static const cardNumberFieldValue = "CardNumber";
  static const expirationFieldValue = "Expiration";
  static const cvvFieldValue = "Cvv";
  static const postalCodeFieldValue = "PostalCode";

  // Text Styles Keys
  static const textColorKey = "textColor";
  static const errorTextColorKey = "errorTextColor";
  static const cursorColorKey = "cursorColor";
  static const hintTextColorKey = "hintTextColor";
  static const textSizeKey = "textSize";
  static const errorTextSizeKey = "errorTextSize";
  static const textAlignmentKey = "textAlignment";
  static const fontAssetKey = "fontAsset";
  static const errorFontAssetKey = "errorFontAsset";
  static const fontNameKey = "fontName";

  // Card type enum values
  static const visaFieldValue = "Visa";
  static const amexFieldValue = "Amex";
  static const discoverFieldValue = "Discover";
  static const masterCardFieldValue = "Mastercard";
  static const unsupportedCardFieldValue = "Unsupported";
  static const unknownCardFieldValue = "Unknown";

  // Currency code enum values
  static const usdCurrencyFieldValue = "USD";
  static const cadCurrencyFieldValue = "CAD";

  // Google Pay checkout status enum values
  static const estimatedDefault = "EstimatedDefault";
  static const finalDefault = "FinalDefault";
  static const finalImmediatePurchase = "FinalImmediatePurchase";

  // Background Style Keys
  static const backgroundColorKey = "backgroundColor";
  static const borderColorKey = "borderColor";
  static const borderWidthKey = "borderWidth";
  static const borderRadiusKey = "borderRadius";

  // Divider Style Keys
  static const dividerColorKey = "dividerColor";
  static const dividerWidthKey = "dividerWidth";

  // Padding Style Keys
  static const startPaddingKey = "startPadding";
  static const endPaddingKey = "endPadding";
  static const topPaddingKey = "topPadding";
  static const bottomPaddingKey = "bottomPadding";

  // View Initializer Argument Keys
  static const hintsArgumentsKey = "hints";
  static const focusedFieldHintsArgumentsKey = "focusedFieldHints";
  static const textStylesArgumentsKey = "textStyles";
  static const backgroundStylesArgumentsKey = "backgroundStyles";
  static const fieldDividerStylesArgumentsKey = "fieldDividerStyles";
  static const errorBackgroundStylesArgumentsKey = "errorBackgroundStyles";
  static const paddingStylesArgumentsKey = "paddingStyles";
  static const errorPaddingStylesArgumentsKey = "errorPaddingStyles";
  static const customErrorMessages = "customErrorMessages";
  static const errorTextAlignmentKey = "errorTextAlignment";
  static const verticalSpacingKey = "verticalSpacing";

  // Custom Error Message Keys
  static const emptyError = "emptyError";
  static const invalidError = "invalidError";
  static const unsupportedCardError = "unsupportedCardError";

  // Alignment Keys
  static const left = "left";
  static const right = "right";
  static const center = "center";

  // Google Pay Button Configuration Keys
  static const googlePayButtonThemeKey = "GooglePayButtonTheme";
  static const googlePayButtonTypeKey = "GooglePayButtonType";
  static const googlePayButtonCornerRadiusKey = "GooglePayButtonCornerRadius";

  // Google Pay Button Theme Keys
  static const googlePayButtonThemeLight = "light";
  static const googlePayButtonThemeDark = "dark";

  // Google Pay Button Type Keys
  static const googlePayButtonTypeBuy = "buy";
  static const googlePayButtonTypeBook = "book";
  static const googlePayButtonTypeCheckout = "checkout";
  static const googlePayButtonTypeDonate = "donate";
  static const googlePayButtonTypeOrder = "order";
  static const googlePayButtonTypePay = "pay";
  static const googlePayButtonTypeSubscribe = "subscribe";
  static const googlePayButtonTypePlain = "plain";

  // Apple Pay Button Configuration Keys
  static const applePayButtonStyleKey = "ApplePayButtonStyle";
  static const applePayButtonTypeKey = "ApplePayButtonType";
  static const applePayButtonCornerRadiusKey = "ApplePayButtonCornerRadius";

  // Apple Pay Button Style Keys
  static const applePayButtonStyleWhite = "white";
  static const applePayButtonStyleWhiteOutline = "whiteOutline";
  static const applePayButtonStyleBlack = "black";
  static const applePayButtonStyleAutomatic = "automatic";

  // Apple Pay Button Type Keys
  static const applePayButtonTypePlain = "plain";
  static const applePayButtonTypeBuy = "buy";
  static const applePayButtonTypeAddMoney = "addMoney";
  static const applePayButtonTypeBook = "book";
  static const applePayButtonTypeCheckout = "checkout";
  static const applePayButtonTypeContinue = "continue";
  static const applePayButtonTypeContribute = "contribute";
  static const applePayButtonTypeDonate = "donate";
  static const applePayButtonTypeInStore = "inStore";
  static const applePayButtonTypeOrder = "order";
  static const applePayButtonTypeReload = "reload";
  static const applePayButtonTypeRent = "rent";
  static const applePayButtonTypeSetUp = "setUp";
  static const applePayButtonTypeSubscribe = "subscribe";
  static const applePayButtonTypeSupport = "support";
  static const applePayButtonTypeTip = "tip";
  static const applePayButtonTypeTopUp = "topUp";

  // Digital Wallet Line Item Keys
  static const digitalWalletLineItemAmountKey = "lineItemAmount";
  static const digitalWalletLineItemTypeKey = "lineItemType";
  static const digitalWalletLineItemLabelKey = "lineItemLabel";
  static const digitalWalletLineItemStatusKey = "lineItemStatus";
  static const digitalWalletLineItemSubtotalLabelKey = "Subtotal";
  static const digitalWalletLineItemTaxLabelKey = "Tax";

  // Google Pay Line Item Keys
  // - DO NOT EDIT THESE VALUES - THEY MAP DIRECTLY TO VALUES IN THE OLO PAY SDK
  static const googlePayLineItemTypeKey = "LineItem";
  static const googlePaySubtotalTypeKey = "Subtotal";
  static const googlePayTaxTypeKey = "Tax";
  static const digitalWalletFinalStatus = "Final";
  static const digitalWalletPendingStatus = "Pending";
}
