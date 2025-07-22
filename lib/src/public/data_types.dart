// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/public/data_classes/card_field.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field_state.dart';
import 'package:olo_pay_sdk/src/public/widgets/single_line/card_details_single_line_text_field_controller.dart';
import 'package:olo_pay_sdk/src/public/widgets/single_line/card_details_single_line_text_field.dart';
import 'package:olo_pay_sdk/src/public/widgets/form_view/card_details_form_text_field_controller.dart';
import 'package:olo_pay_sdk/src/public/widgets/form_view/card_details_form_text_field.dart';
import 'package:olo_pay_sdk/src/public/widgets/cvv/cvv_text_field_controller.dart';
import 'package:olo_pay_sdk/src/public/widgets/cvv/cvv_text_field.dart';
import 'package:olo_pay_sdk/src/public/widgets/digital_wallet_button/digital_wallet_button.dart';

// Single Line Text Field
/// Callback signature for when a [CardDetailsSingleLineTextField]'s controller has been created and is ready to be used
typedef CardDetailsSingleLineTextFieldControllerCreated = void Function(
    CardDetailsSingleLineTextFieldController controller);

/// Callback signature for when a [CardDetailsSingleLineTextField]'s state changes due to user-entered input
typedef CardDetailsInputChanged = void Function(
    bool isValid, Map<CardField, CardFieldState> fieldStates);

/// Callback signature for when a [CardDetailsSingleLineTextField]'s valid state changes
typedef CardDetailsValidStateChanged = void Function(
    bool isValid, Map<CardField, CardFieldState> fieldStates);

/// Callback signature for when a [CardDetailsSingleLineTextField]'s
/// focused state changes
///
/// If [focusedField] is null that means the widget itself lost focus, otherwise
/// it represents the field that currently has focus and is being edited by the
/// user
typedef CardDetailsFocusChanged = void Function(
  CardField? focusedField,
  bool isValid,
  Map<CardField, CardFieldState> fieldStates,
);

/// Callback signature for when a [CardDetailsSingleLineTextField] or
/// [CardDetailsFormTextField] error message changes
typedef CardDetailsErrorMessageChanged = void Function(String errorMessage);

// Card Details Form Text Field
/// Callback signature for when a [CardDetailsFormTextField]'s controller has been created and is ready to be used
typedef CardDetailsFormTextFieldControllerCreated = void Function(
    CardDetailsFormTextFieldController controller);

/// Callback signature for when a [CardDetailsFormTextField]'s valid state
/// changes
typedef CardDetailsFormValidStateChanged = void Function(bool isValid);

// Cvv Text Field
/// Callback signature for when a [CvvTextField]'s controller has been created and is ready to be used
typedef CvvTextFieldControllerCreated = void Function(
    CvvTextFieldController controller);

/// Callback signature for when a [CvvTextField]'s error message changes
typedef CvvErrorMessageChanged = void Function(String errorMessage);

/// Callback signature for when a [CvvTextField]'s state changes due to user-entered input
typedef CvvInputChanged = void Function(CardFieldState fieldStates);

/// Callback signature for when a [CvvTextField]'s valid state changes
typedef CvvValidStateChanged = void Function(CardFieldState fieldState);

/// Callback signature for when a [CvvTextField]'s focused state changes
typedef CvvFocusChanged = void Function(CardFieldState fieldStates);

// Digital Wallets
/// Callback signature for when the ready status of digital wallets changes
///
/// [isReady] determines whether or not digital wallets are ready to process payments
typedef DigitalWalletReadyChanged = void Function(bool isReady);

/// Callback signature for when a [DigitalWalletButton] has been clicked
typedef OnDigitalWalletButtonClicked = void Function();
