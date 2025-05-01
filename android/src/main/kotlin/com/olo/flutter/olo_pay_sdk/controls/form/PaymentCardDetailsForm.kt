// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.controls.form

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Typeface
import android.os.Build
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import androidx.appcompat.app.AppCompatDelegate
import com.olo.flutter.olo_pay_sdk.R
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.olopay.controls.callbacks.FormValidCallback
import com.olo.olopay.data.CardField
import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.extensions.from
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.getStringArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.api.OloPayAPI
import com.olo.olopay.data.CardErrorType
import com.olo.olopay.exceptions.ApiConnectionException
import com.olo.olopay.exceptions.ApiException
import com.olo.olopay.exceptions.CardException
import com.olo.olopay.exceptions.InvalidRequestException
import com.olo.olopay.exceptions.OloPayException
import com.olo.olopay.exceptions.RateLimitException
import com.stripe.android.core.exception.AuthenticationException
import com.olo.flutter.olo_pay_sdk.data.GlobalConstants
import com.olo.flutter.olo_pay_sdk.utils.OloPayLog
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.olo.olopay.controls.PaymentCardDetailsForm as OloPaymentCardDetailsForm


@SuppressLint("InflateParams")
internal class PaymentCardDetailsForm (
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler, FormValidCallback {
    private val methodChannel: MethodChannel

    private var formInputView: OloPaymentCardDetailsForm = LayoutInflater.from(context).inflate(
        R.layout.flutter_olopay_form_view,
        null
    ) as OloPaymentCardDetailsForm

    private val defaultFont: Typeface = formInputView.getFont()

    init {
        formInputView.formValidCallback = this

        loadCustomArgs(args)

        methodChannel = MethodChannel(messenger, DataKeys.PaymentCardDetailsFormBaseMethodChannelKey + id)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return formInputView
    }

    override fun dispose() {}

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when(methodCall.method){
            DataKeys.RefreshUiMethod -> refreshUI(methodCall, result)
            DataKeys.CreatePaymentMethodKey -> createPaymentMethod(result)
            DataKeys.IsValidMethodKey -> isValid(result)
            DataKeys.GetCardTypeMethodKey -> getCardType(result)
            DataKeys.IsEnabledMethodKey -> isEnabled(result)
            DataKeys.ClearFieldsMethodKey -> clearFields(result)
            DataKeys.RequestFocusMethodKey -> requestFocus(methodCall, result)
            DataKeys.ClearFocusMethodKey -> clearFocus(result)
            else -> result.notImplemented()
        }
    }

    private fun createPaymentMethod(result: MethodChannel.Result) {
        if (!formInputView.isValid) {
            result.error(ErrorCodes.InvalidCardDetails, "Card details are invalid", null)
            return
        }

        CoroutineScope(Dispatchers.IO).launch {
            val params = formInputView.paymentMethodParams!!

            try {
                val paymentMethod = OloPayAPI().createPaymentMethod(formInputView.context, params)
                result.success(paymentMethod.toMap())
            } catch (e: ApiException) {
                result.error(ErrorCodes.ApiError, e.message, null)
            } catch(e: InvalidRequestException) {
                result.error(ErrorCodes.InvalidRequest, e.message, null)
            } catch(e: ApiConnectionException) {
                result.error(ErrorCodes.Connection, e.message, null)
            } catch(e: RateLimitException) {
                result.error(ErrorCodes.RateLimit, e.message, null)
            } catch(e: AuthenticationException) {
                result.error(ErrorCodes.Authentication, e.message, null)
            } catch(e: CardException) {
                when(e.type) {
                    CardErrorType.InvalidNumber -> result.error(ErrorCodes.InvalidNumber, e.message, null)
                    CardErrorType.InvalidExpMonth -> result.error(ErrorCodes.InvalidExpiration, e.message, null)
                    CardErrorType.InvalidExpYear -> result.error(ErrorCodes.InvalidExpiration, e.message, null)
                    CardErrorType.InvalidCVV -> result.error(ErrorCodes.InvalidCvv, e.message, null)
                    CardErrorType.InvalidZip -> result.error(ErrorCodes.InvalidPostalCode, e.message, null)
                    CardErrorType.ExpiredCard -> result.error(ErrorCodes.ExpiredCard, e.message, null)
                    CardErrorType.CardDeclined -> result.error(ErrorCodes.CardDeclined, e.message, null)
                    CardErrorType.ProcessingError -> result.error(ErrorCodes.ProcessingError, e.message, null)
                    CardErrorType.UnknownCardError -> result.error(ErrorCodes.UnknownCardError, e.message, null)
                }
            } catch(e: OloPayException) {
                result.error(ErrorCodes.GeneralError, e.message, null)
            }
        }
    }

    private fun isValid(result: MethodChannel.Result) {
        result.success(formInputView.isValid)
    }

    private fun getCardType(result: MethodChannel.Result) {
        result.success(formInputView.cardBrand.description)
    }

    private fun isEnabled(result: MethodChannel.Result) {
        result.success(formInputView.isEnabled)
    }

    private fun clearFields(result: MethodChannel.Result) {
        formInputView.clearFields()
        result.success(null)
    }

    private fun requestFocus(call: MethodCall, result: MethodChannel.Result) {
        val focusField = try {
            call.getStringArgOrErrorResult(
                key = DataKeys.FocusFieldParameterKey,
                default = DataKeys.CardNumberFieldValueKey,
                baseError = "Unable to set focus field",
                acceptEmptyValue = false,
                result = result
            )
        } catch(_: Exception) {
            return
        }
        formInputView.requestFocus(CardField.from(focusField), true)
        result.success(null)
    }

    private fun clearFocus(result: MethodChannel.Result) {
        formInputView.dismissKeyboard()
        result.success(null)
    }


    override fun onInputChanged(isValid: Boolean, invalidFields: Set<CardField>) {
        // This needs to be implemented due to a small bug in the Android SDK. There should have
        // been a default implementation added to this method, allowing it to be implemented
        // optionally, but this minor detail was apparently missed.
    }

    override fun onValidStateChanged(isValid: Boolean, invalidFields: Set<CardField>) {
        val args = mapOf(DataKeys.IsValidKey to isValid)
        methodChannel.invokeMethod(DataKeys.OnValidStateChangedEventHandlerKey, args)
    }

    private fun refreshUI(call: MethodCall, result: MethodChannel.Result) {
        call.argument<Any>(DataKeys.CreationParameters)?.let { params ->
            loadCustomArgs(params)
        }
        result.success(null)
    }

    private fun loadCustomArgs(args: Any?) {
        val widgetArgs = args as? Map<*, *> ?: return

        (widgetArgs[DataKeys.DarkModeParameterKey] as? Boolean)?.let {
            AppCompatDelegate.setDefaultNightMode(if (it) {
                AppCompatDelegate.MODE_NIGHT_YES
            } else {
                AppCompatDelegate.MODE_NIGHT_NO
            })
        }

        val hints = widgetArgs[DataKeys.HintsArgumentKey] as? Map<*, *>
        if (hints != null && hints.isNotEmpty()) {
            loadHints(hints)
        }

        val focusedFieldHints = widgetArgs[DataKeys.FocusedFieldHintsArgumentKey] as? Map<*, *>
        if (focusedFieldHints != null && focusedFieldHints.isNotEmpty()) {
            loadFocusedFieldHints(focusedFieldHints)
        }

        val textStyles = widgetArgs[DataKeys.TextStylesArgumentsKey] as? Map<*, *>
        if (textStyles != null && textStyles.isNotEmpty()) {
            loadTextStyles(textStyles)
        }

        val backgroundStyles = widgetArgs[DataKeys.BackgroundStylesArgumentsKey] as? Map<*, *>
        if (backgroundStyles != null && backgroundStyles.isNotEmpty()) {
            loadBackgroundStyles(backgroundStyles)
        }

        val fieldDividerStyles = widgetArgs[DataKeys.FieldDividerStylesArgumentsKey] as? Map<*, *>
        if (fieldDividerStyles != null && fieldDividerStyles.isNotEmpty()) {
            loadFieldDividerStyles(fieldDividerStyles)
        }

        val errorBackgroundStyles = widgetArgs[DataKeys.ErrorBackgroundStylesArgumentsKey] as? Map<*, *>
        if (errorBackgroundStyles != null && errorBackgroundStyles.isNotEmpty()) {
            loadErrorBackgroundStyles(errorBackgroundStyles)
        }

        val paddingStyles = widgetArgs[DataKeys.PaddingStylesArgumentsKey] as? Map<*, *>
        if (paddingStyles != null && paddingStyles.isNotEmpty()) {
            loadPaddingStyles(paddingStyles)
        }

        val errorPaddingStyles = widgetArgs[DataKeys.ErrorPaddingStylesArgumentsKey] as? Map<*, *>
        if (errorPaddingStyles != null && errorPaddingStyles.isNotEmpty()) {
            loadErrorPaddingStyles(errorPaddingStyles)
        }

        (widgetArgs[DataKeys.VerticalSpacingKey] as? Double)?.let {
            formInputView.setVerticalSpacing(it.toInt())
        }

        (widgetArgs[DataKeys.ErrorTextAlignmentKey] as? String?).let {
            val position = when(it) {
                DataKeys.GravityCenterKey -> Gravity.CENTER
                DataKeys.GravityRightKey -> Gravity.RIGHT or Gravity.CENTER_VERTICAL
                else -> Gravity.LEFT or Gravity.CENTER_VERTICAL
            }

            formInputView.setErrorGravity(position)
        }

        (widgetArgs[DataKeys.EnabledParameterKey] as? Boolean)?.let {
            formInputView.isEnabled = it
        }
    }

    private fun loadHints(hints: Map<*, *>) {
        val numberHint = hints[CardField.CardNumber.toString()] as? String
        if (numberHint != null) {
            formInputView.setHintText(CardField.CardNumber, numberHint)
        }

        val expirationHint = hints[CardField.Expiration.toString()] as? String
        if (expirationHint != null) {
            formInputView.setHintText(CardField.Expiration, expirationHint)
        }

        val cvvHint = hints[CardField.Cvv.toString()] as? String
        if (cvvHint != null) {
            formInputView.setHintText(CardField.Cvv, cvvHint)
        }

        val postalCodeHint = hints[CardField.PostalCode.toString()] as? String
        if (postalCodeHint != null) {
            formInputView.setHintText(CardField.PostalCode, postalCodeHint)
        }
    }

    private fun loadFocusedFieldHints(hints: Map<*, *>) {
        val numberHint = hints[CardField.CardNumber.toString()] as? String
        if (numberHint != null) {
            formInputView.setFocusedHintText(CardField.CardNumber, numberHint)
        }

        val expirationHint = hints[CardField.Expiration.toString()] as? String
        if (expirationHint != null) {
            formInputView.setFocusedHintText(CardField.Expiration, expirationHint)
        }

        val cvvHint = hints[CardField.Cvv.toString()] as? String
        if (cvvHint != null) {
            formInputView.setFocusedHintText(CardField.Cvv, cvvHint)
        }

        val postalCodeHint = hints[CardField.PostalCode.toString()] as? String
        if (postalCodeHint != null) {
            formInputView.setFocusedHintText(CardField.PostalCode, postalCodeHint)
        }
    }

    private fun loadTextStyles(textStyles: Map<*, *>) {
        if(Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            val textColor = textStyles[DataKeys.TextColorKey] as? String
            if (!textColor.isNullOrBlank()) {
                formInputView.setTextColor(textColor)
            }

            val errorTextColor = textStyles[DataKeys.ErrorTextColorKey] as? String
            if (!errorTextColor.isNullOrBlank()) {
                formInputView.setErrorTextColor(errorTextColor)
            }

            val hintTextColor = textStyles[DataKeys.HintTextColorKey] as? String
            if (!hintTextColor.isNullOrBlank()) {
                formInputView.setHintTextColor(hintTextColor)
            }

            val focusedHintTextColor = textStyles[DataKeys.FocusedHintTextColorKey] as? String
            if (!focusedHintTextColor.isNullOrBlank()) {
                formInputView.setFocusedHintTextColor(focusedHintTextColor)
            }
        }

        val cursorColor = textStyles[DataKeys.CursorColorKey] as? String
        if (!cursorColor.isNullOrBlank() && Build.VERSION.SDK_INT >= GlobalConstants.ApiQuinceTart) {
            formInputView.setCursorColor(cursorColor)
        }

        (textStyles[DataKeys.TextSizeKey] as? Double)?.let {
            formInputView.setTextSize(it.toFloat())
        }

        (textStyles[DataKeys.ErrorTextSizeKey] as? Double)?.let {
            formInputView.setErrorTextSize(it.toFloat())
        }

        val fontAsset = textStyles[DataKeys.FontAssetKey] as? String
        if(!fontAsset.isNullOrBlank()) {
            try{
                val assetKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(fontAsset)
                val font = Typeface.createFromAsset(formInputView.context.assets, assetKey)
                formInputView.setFont(font)
            } catch (error: Exception) {
                OloPayLog.e(OloPayLog.getStackTrace(error))
                formInputView.setFont(defaultFont)
            }
        } else if(formInputView.getFont() != defaultFont){
            formInputView.setFont(defaultFont)
        }

        val errorFontAsset = textStyles[DataKeys.ErrorFontAssetKey] as? String
        if(!errorFontAsset.isNullOrBlank()) {
            try{
                val assetKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(errorFontAsset)
                val font = Typeface.createFromAsset(formInputView.context.assets, assetKey)
                formInputView.setErrorFont(font)
            } catch (error: Exception) {
                OloPayLog.e(OloPayLog.getStackTrace(error))
                formInputView.setErrorFont(defaultFont)
            }
        } else if(formInputView.getErrorFont() != defaultFont){
            formInputView.setErrorFont(defaultFont)
        }
    }

    private fun loadBackgroundStyles(backgroundStyles: Map<*, *>) {
        val displayMetrics = formInputView.context.resources.displayMetrics

        //Need to convert from dp values to px values
        val borderWidthPx = (backgroundStyles[DataKeys.BorderWidthKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        val borderRadiusPx = (backgroundStyles[DataKeys.BorderRadiusKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        if (Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            formInputView.setCardBackgroundStyle(
                backgroundColorHex = backgroundStyles[DataKeys.BackgroundColorKey] as? String,
                borderColorHex = backgroundStyles[DataKeys.BorderColorKey] as? String,
                borderWidthPx = borderWidthPx,
                borderRadiusPx = borderRadiusPx
            )
        }
    }
    private fun loadFieldDividerStyles(fieldDividerStyles: Map<*, *>) {
        val displayMetrics = formInputView.context.resources.displayMetrics

        //Need to convert from dp values to px values
        val fieldDividerWidthPx = (fieldDividerStyles[DataKeys.FieldDividerWidthKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        val fieldDividerColor = fieldDividerStyles[DataKeys.FieldDividerColorKey] as? String

        if (Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            if(fieldDividerColor != null) {
                formInputView.setFieldDividerColor(fieldDividerColor)
            }

            if(fieldDividerWidthPx != null) {
                formInputView.setFieldDividerWidth(fieldDividerWidthPx.toInt())
            }
        }
    }

    private fun loadErrorBackgroundStyles(errorBackgroundStyles: Map<*, *>) {
        val displayMetrics = formInputView.context.resources.displayMetrics

        //Need to convert from dp values to px values
        val borderWidthPx = (errorBackgroundStyles[DataKeys.BorderWidthKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        val borderRadiusPx = (errorBackgroundStyles[DataKeys.BorderRadiusKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        if (Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            formInputView.setErrorBackgroundStyle(
                backgroundColorHex = errorBackgroundStyles[DataKeys.BackgroundColorKey] as? String,
                borderColorHex = errorBackgroundStyles[DataKeys.BorderColorKey] as? String,
                borderWidthPx = borderWidthPx,
                borderRadiusPx = borderRadiusPx
            )
        }
    }

    private fun loadPaddingStyles(paddingStyles: Map<*, *>) {
        val displayMetrics = formInputView.context.resources.displayMetrics

        val startPadding = (paddingStyles[DataKeys.StartPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        val endPadding = (paddingStyles[DataKeys.EndPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }
        val topPadding = (paddingStyles[DataKeys.TopPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        val bottomPadding = (paddingStyles[DataKeys.BottomPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        formInputView.setCardPadding(
            startPx = startPadding,
            endPx = endPadding,
            topPx = topPadding,
            bottomPx = bottomPadding
        )
    }

    private fun loadErrorPaddingStyles(paddingStyles: Map<*, *>) {
        val displayMetrics = formInputView.context.resources.displayMetrics

        val startPadding = (paddingStyles[DataKeys.StartPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        val endPadding = (paddingStyles[DataKeys.EndPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }
        val topPadding = (paddingStyles[DataKeys.TopPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        val bottomPadding = (paddingStyles[DataKeys.BottomPaddingKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics).toInt()
        }

        formInputView.setErrorPadding(
            startPx = startPadding,
            endPx = endPadding,
            topPx = topPadding,
            bottomPx = bottomPadding
        )
    }
}