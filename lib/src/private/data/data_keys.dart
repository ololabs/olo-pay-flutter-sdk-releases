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

  // Method Channel Keys
  static const cvvBaseMethodChannelKey = '$bridgePrefix/$cvvViewType:';
  static const oloPaySdkMethodChannelKey = '$bridgePrefix/sdk';
  static const singleLineBaseMethodChannelKey =
      '$bridgePrefix/$singleLineViewType:';

  // View Registration Keys
  static const cvvViewTypeKey = '$bridgePrefix/$cvvViewType';
  static const singleLineViewTypeKey = '$bridgePrefix/$singleLineViewType';

  // Native Method Keys
  static const initializeMethodKey = "initialize";
  static const initializeMetadataKey = "initializeMetadata";
  static const initializeGooglePayMethodKey = "initializeGooglePay";
  static const changeGooglePayVendorMethodKey = "changeGooglePayVendor";
  static const isInitializedMethodKey = "isInitialized";
  static const isDigitalWalletReadyMethodKey = "isDigitalWalletReady";
  static const createPaymentMethodKey = "createPaymentMethod";
  static const createCvvUpdateToken = "createCvvUpdateToken";
  static const createDigitalWalletPaymentMethodKey =
      "createDigitalWalletPaymentMethod";
  static const getStateMethodKey = "getState";
  static const isValidMethodKey = "isValid";
  static const getCardTypeMethodKey = "getCardType";
  static const setEnabledMethodKey = "setEnabled";
  static const isEnabledMethodKey = "isEnabled";
  static const hasErrorMessageMethodKey = "hasErrorMessage";
  static const getErrorMessageMethodKey = "getErrorMessage";
  static const clearFieldsMethodKey = "clearFields";
  static const requestFocusMethodKey = "requestFocus";
  static const clearFocusMethodKey = "clearFocus";
  static const refreshUiMethod = "refreshUI";
  static const getFontNamesMethodKey = "getFontNames";

  // Native Method Parameter Keys
  static const enabledParameterKey = "enabled";
  static const ignoreUneditedFieldsParameterKey = "ignoreUneditedFields";
  static const digitalWalletAmountParameterKey = "amount";
  static const digitalWalletCurrencyCodeKey = "currencyCode";
  static const googlePayCurrencyMultiplierKey = "currencyMultiplier";
  static const applePayMerchantIdParameterKey = "merchantId";
  static const applePayCompanyLabelParameterKey = "companyLabel";
  static const digitalWalletCountryCodeParameterKey = "countryCode";
  static const googlePayMerchantNameParameterKey = "merchantName";
  static const googlePayProductionEnvironmentParameterKey =
      "googlePayProductionEnvironment";
  static const googlePayFullAddressFormatParameterKey = "fullAddressFormat";
  static const googlePayExistingPaymentMethodRequiredParameterKey =
      "existingPaymentMethodRequired";
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
  static const pmIsDigitalWalletKey = "isDigitalWallet";

  // Cvv Update Token Keys
  static const cvvIdKey = "id";

  // Event Handler Keys
  static const onFocusChangedEventHandlerKey = "onFocusChanged";
  static const onInputChangedEventHandlerKey = "onInputChanged";
  static const onValidStateChangedEventHandlerKey = "onValidStateChanged";
  static const onErrorMessageChangedEventHandlerKey = "onErrorMessageChanged";
  static const digitalWalletReadyEventHandlerKey = "digitalWalletReadyEvent";

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
  static const textAlignmentKey = "textAlignment";
  static const fontAssetKey = "fontAsset";
  static const fontNameKey = "fontName";

  // Card type enum values
  static const visaFieldValue = "Visa";
  static const amexFieldValue = "Amex";
  static const discoverFieldValue = "Discover";
  static const masterCardFieldValue = "Mastercard";
  static const unsupportedCardFieldValue = "Unsupported";
  static const unknownCardFieldValue = "Unknown";

  // Background Style Keys
  static const backgroundColorKey = "backgroundColor";
  static const borderColorKey = "borderColor";
  static const borderWidthKey = "borderWidth";
  static const borderRadiusKey = "borderRadius";

  // Padding Style Keys
  static const startPaddingKey = "startPadding";
  static const endPaddingKey = "endPadding";
  static const topPaddingKey = "topPadding";
  static const bottomPaddingKey = "bottomPadding";

  // View Initializer Argument Keys
  static const hintsArgumentsKey = "hints";
  static const textStylesArgumentsKey = "textStyles";
  static const backgroundStylesArgumentsKey = "backgroundStyles";
  static const paddingStylesArgumentsKey = "paddingStyles";
  static const customErrorMessages = "customErrorMessages";

  // Custom Error Message Keys
  static const emptyError = "emptyError";
  static const invalidError = "invalidError";
  static const unsupportedCardError = "unsupportedCardError";

  // Alignment Keys
  static const left = "left";
  static const right = "right";
  static const center = "center";
}
