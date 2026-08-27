// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.controls.singleline

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.graphics.Typeface
import android.os.Build
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import com.olo.flutter.olo_pay_sdk.R
import com.olo.flutter.olo_pay_sdk.data.CustomErrorMessages
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.data.GlobalConstants
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.flutter.olo_pay_sdk.utils.OloPayLog
import com.olo.olopay.api.OloPayAPI
import com.olo.olopay.controls.callbacks.CardInputListener
import com.olo.olopay.controls.callbacks.ConfigurationChangeListener
import com.olo.olopay.data.CardErrorType
import com.olo.olopay.data.CardField
import com.olo.olopay.data.ICardFieldState
import com.olo.olopay.exceptions.ApiConnectionException
import com.olo.olopay.exceptions.ApiException
import com.olo.olopay.exceptions.CardException
import com.olo.olopay.exceptions.InvalidRequestException
import com.olo.olopay.exceptions.OloPayException
import com.olo.olopay.exceptions.RateLimitException
import com.stripe.android.core.exception.AuthenticationException
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import com.olo.olopay.controls.PaymentCardDetailsSingleLineView as OloPaySingleLineView


@SuppressLint("InflateParams")
internal class PaymentCardDetailsSingleLineView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler, CardInputListener, ConfigurationChangeListener {
    private val methodChannel: MethodChannel

    private var cardInputView: OloPaySingleLineView = LayoutInflater.from(context).inflate(
        R.layout.flutter_olopay_single_line_view,
        null
    ) as OloPaySingleLineView


    private val defaultFont = cardInputView.getFont()
    private var _customErrorMessages: CustomErrorMessages? = null

    init {
        cardInputView.configurationChangeListener = this
        cardInputView.displayErrors = false
        cardInputView.cardInputListener = this

        loadCustomArgs(args)

        methodChannel = MethodChannel(messenger, DataKeys.SingleLineBaseMethodChannelKey + id)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return cardInputView
    }

    override fun dispose(){}

    // Device orientation change apparently does not follow the same flow as in native Android, which
    // results in the layout not getting updated properly for new widths. The size gets updated, but
    // each individual field size is not, resulting in overlapping fields or inaccessible fields that
    // are outside the bounds of the view. This little hack fixes that. By forcing focus on specific
    // fields, it triggers a recalculation of Stripe's individual fields, and fixes this issue.
    // As of right now, this appears to be the only way to fix this issue, as traditional methods
    // involving invalidate(), requestLayout(), and forceLayout() do not work.
    override fun onConfigurationChanged(newConfig: Configuration?) {
        val initialFocused: CardField? = getFocusedField(cardInputView.fieldStates)

        // Switching focus to these fields guarantees a recalculation of field size on Stripe's
        // control will occur.
        val newFocusedField = when (initialFocused) {
            CardField.CardNumber -> CardField.Expiration
            CardField.Expiration -> CardField.CardNumber
            CardField.Cvv -> CardField.CardNumber
            CardField.PostalCode -> CardField.CardNumber
            null -> CardField.Expiration
        }

        // If there wasn't a focused field, setting the focus on the CardNumber field makes the most
        // sense since it's the first field users interact with, and this second focus is the key
        // to getting the control to display properly in the new configuration.
        //
        // Attempts to clear focus after this, in the case that a field didn't have focus to begin
        // with, appear to cause too much work on the UI thread, and focus doesn't consistently get
        // cleared. Rather than have inconsistent results, we just don't attempt to clear the focus.
        val restoredFocusField = initialFocused ?: CardField.CardNumber

        // Important: This should not be in a post call
        cardInputView.requestFocus(newFocusedField, false)

        // This delay is important, as it allows the view time to finish the previous focus call
        // before attempting this one. The native Android SDK has logic where, in certain scenarios,
        // It can take up to 300ms to request focus, so this delay should never be less than that.
        cardInputView.postDelayed({
            cardInputView.requestFocus(restoredFocusField, false)
        }, FocusDelayMs)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when(methodCall.method) {
            DataKeys.CreatePaymentMethodKey -> createPaymentMethod(result)
            DataKeys.GetStateMethodKey -> getState(result)
            DataKeys.IsValidMethodKey -> isValid(result)
            DataKeys.GetCardTypeMethodKey -> getCardType(result)
            DataKeys.IsEnabledMethodKey -> isEnabled(result)
            DataKeys.HasErrorMessageMethodKey -> hasErrorMessage(methodCall, result)
            DataKeys.GetErrorMessageMethodKey -> getErrorMessage(methodCall, result)
            DataKeys.ClearFieldsMethodKey -> clearFields(result)
            DataKeys.RequestFocusMethodKey -> requestFocus(result)
            DataKeys.ClearFocusMethodKey -> clearFocus(result)
            DataKeys.RefreshUiMethod -> refreshUI(methodCall, result)
            else -> result.notImplemented()
        }
    }

    private fun createPaymentMethod(result: MethodChannel.Result) {
        if (!cardInputView.isValid) {
            val errorCode = getErrorCode()
            val errorMessage = getErrorMessage(false)
            result.error(errorCode, errorMessage, null)
            return
        }

        CoroutineScope(Dispatchers.IO).launch {
            val params = cardInputView.paymentMethodParams!!

            try {
                val paymentMethod = OloPayAPI().createPaymentMethod(cardInputView.context, params)
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

    private fun getState(result: MethodChannel.Result) {
        result.success(cardInputView.fieldStates.toMap())
    }

    private fun isValid(result: MethodChannel.Result) {
        result.success(cardInputView.isValid)
    }

    private fun getCardType(result: MethodChannel.Result) {
        result.success(cardInputView.cardBrand.description)
    }

    private fun isEnabled(result: MethodChannel.Result) {
        result.success(cardInputView.isEnabled)
    }

    private fun hasErrorMessage(call: MethodCall, result: MethodChannel.Result) {
        val ignoreUneditedFields = try {
            call.getArgOrErrorResult<Boolean>(
                DataKeys.IgnoreUneditedFieldsParameterKey,
                "Unable to check for error message",
                result
            )
        } catch (_: Exception) {
            return
        }

        result.success(cardInputView.hasErrorMessage(ignoreUneditedFields))
    }

    private fun getErrorMessage(call: MethodCall, result: MethodChannel.Result) {
        val ignoreUneditedFields = try {
            call.getArgOrErrorResult<Boolean>(
                DataKeys.IgnoreUneditedFieldsParameterKey,
                "Unable to get error message",
                result
            )
        } catch (_: Exception) {
            return
        }

        result.success(getErrorMessage(ignoreUneditedFields))
    }

    private fun getErrorMessage(ignoreUneditedFields: Boolean): String {
        if(cardInputView.isValid || !cardInputView.hasErrorMessage(ignoreUneditedFields)) {
            return ""
        }

        val defaultErrorMessage = cardInputView.getErrorMessage(ignoreUneditedFields)
        return (_customErrorMessages?.getCustomErrorMessage(ignoreUneditedFields, cardInputView.fieldStates, cardInputView.cardBrand) ?: defaultErrorMessage)
    }

    private fun clearFields(result: MethodChannel.Result) {
        cardInputView.clearFields()
        result.success(null)
    }

    private fun requestFocus(result: MethodChannel.Result) {
        cardInputView.requestFocus(CardField.CardNumber, true)
        result.success(null)
    }

    private fun clearFocus(result: MethodChannel.Result) {
        cardInputView.clearFocus()
        result.success(null)
    }

    private fun refreshUI(call: MethodCall, result: MethodChannel.Result) {
        call.argument<Any>(DataKeys.CreationParameters)?.let { params ->
            loadCustomArgs(params)
        }
        result.success(null)
    }

    private fun getErrorCode(): String {
        if(!cardInputView.fieldStates[CardField.CardNumber]!!.isValid) {
            return ErrorCodes.InvalidNumber
        } else if (!cardInputView.fieldStates[CardField.Expiration]!!.isValid) {
            return ErrorCodes.InvalidExpiration
        } else if(!cardInputView.fieldStates[CardField.Cvv]!!.isValid) {
            return ErrorCodes.InvalidCvv
        } else if(!cardInputView.fieldStates[CardField.PostalCode]!!.isValid) {
            return ErrorCodes.InvalidPostalCode
        }

        return ErrorCodes.InvalidCardDetails
    }

    override fun onFocusChange(field: CardField?, fieldStates: Map<CardField, ICardFieldState>) {
        val args = mapOf(
            DataKeys.IsValidKey to cardInputView.isValid,
            DataKeys.FocusedFieldParameterKey to (field?.toString() ?: ""),
            DataKeys.FieldStatesParameterKey to fieldStates.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    override fun onValidStateChanged(isValid: Boolean, fieldStates: Map<CardField, ICardFieldState>) {
        val args = mapOf(
            DataKeys.IsValidKey to isValid,
            DataKeys.FieldStatesParameterKey to fieldStates.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnValidStateChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    override fun onInputChanged(isValid: Boolean, fieldStates: Map<CardField, ICardFieldState>) {
        val args = mapOf(
            DataKeys.IsValidKey to isValid,
            DataKeys.FieldStatesParameterKey to fieldStates.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnInputChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    private fun emitErrorMessage() {
        methodChannel.invokeMethod(DataKeys.OnErrorMessageChangedEventHandlerKey, getErrorMessage(true))
    }

    private fun loadCustomArgs(args: Any?) {
        val widgetArgs = args as? Map<*, *> ?: return

        val hints = widgetArgs[DataKeys.HintsArgumentKey] as? Map<*, *>
        if (hints != null && hints.isNotEmpty()) {
            loadHints(hints)
        }

        val textStyles = widgetArgs[DataKeys.TextStylesArgumentsKey] as? Map<*, *>
        if (textStyles != null && textStyles.isNotEmpty()) {
            loadTextStyles(textStyles)
        }

        val backgroundStyles = widgetArgs[DataKeys.BackgroundStylesArgumentsKey] as? Map<*, *>
        if (backgroundStyles != null && backgroundStyles.isNotEmpty()) {
            loadBackgroundStyles(backgroundStyles)
        }

        val paddingStyles = widgetArgs[DataKeys.PaddingStylesArgumentsKey] as? Map<*, *>
        if (paddingStyles != null && paddingStyles.isNotEmpty()) {
            loadPaddingStyles(paddingStyles)
        }

        val customErrorMessages = widgetArgs[DataKeys.CustomErrorMessagesArgumentsKey] as? Map<*, *>
        _customErrorMessages = if (!customErrorMessages.isNullOrEmpty()) {
            CustomErrorMessages(customErrorMessages)
        } else {
            null
        }

        (widgetArgs[DataKeys.EnabledParameterKey] as? Boolean)?.let {
            cardInputView.isEnabled = it
        }
    }

    private fun loadHints(hints: Map<*, *>) {
        val numberHint = hints[CardField.CardNumber.toString()] as? String
        if (numberHint != null) {
            cardInputView.setHintText(CardField.CardNumber, numberHint)
        }

        val expirationHint = hints[CardField.Expiration.toString()] as? String
        if (expirationHint != null) {
            cardInputView.setHintText(CardField.Expiration, expirationHint)
        }

        val cvvHint = hints[CardField.Cvv.toString()] as? String
        if (cvvHint != null) {
            cardInputView.setHintText(CardField.Cvv, cvvHint)
        }

        val postalCodeHint = hints[CardField.PostalCode.toString()] as? String
        if (postalCodeHint != null) {
            cardInputView.setHintText(CardField.PostalCode, postalCodeHint)
        }
    }

    private fun loadTextStyles(textStyles: Map<*, *>) {
        if(Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            val textColor = textStyles[DataKeys.TextColorKey] as? String
            if (!textColor.isNullOrBlank()) {
                cardInputView.setTextColor(textColor)
            }

            val errorTextColor = textStyles[DataKeys.ErrorTextColorKey] as? String
            if (!errorTextColor.isNullOrBlank()) {
                cardInputView.setErrorTextColor(errorTextColor)
            }

            val hintTextColor = textStyles[DataKeys.HintTextColorKey] as? String
            if (!hintTextColor.isNullOrBlank()) {
                cardInputView.setHintTextColor(hintTextColor)
            }
        }

        val cursorColor = textStyles[DataKeys.CursorColorKey] as? String
        if (!cursorColor.isNullOrBlank() && Build.VERSION.SDK_INT >= GlobalConstants.ApiQuinceTart) {
            cardInputView.setCursorColor(cursorColor)
        }

        (textStyles[DataKeys.TextSizeKey] as? Double)?.let {
            cardInputView.setTextSize(it.toFloat())
        }

        val fontAsset = textStyles[DataKeys.FontAssetKey] as? String
        if(!fontAsset.isNullOrBlank()) {
            try{
                val assetKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(fontAsset)
                val font = Typeface.createFromAsset(cardInputView.context.assets, assetKey)
                cardInputView.setFont(font)
            } catch (error: Exception) {
                OloPayLog.e(OloPayLog.getStackTrace(error))
                cardInputView.setFont(defaultFont)
            }
        } else if(cardInputView.getFont() != defaultFont){
            cardInputView.setFont(defaultFont)
        }
    }

    private fun loadBackgroundStyles(backgroundStyles: Map<*, *>) {
        val displayMetrics = cardInputView.context.resources.displayMetrics

        //Need to convert from dp values to px values
        val borderWidthPx = (backgroundStyles[DataKeys.BorderWidthKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        val borderRadiusPx = (backgroundStyles[DataKeys.BorderRadiusKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        if (Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            cardInputView.setCardBackgroundStyle(
                backgroundColorHex = backgroundStyles[DataKeys.BackgroundColorKey] as? String,
                borderColorHex = backgroundStyles[DataKeys.BorderColorKey] as? String,
                borderWidthPx = borderWidthPx,
                borderRadiusPx = borderRadiusPx)
        }
    }

    private fun loadPaddingStyles(paddingStyles: Map<*, *>) {
        val displayMetrics = cardInputView.context.resources.displayMetrics

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

        cardInputView.setCardPadding(
            startPx = startPadding,
            endPx = endPadding,
            topPx = topPadding,
            bottomPx = bottomPadding
        )
    }

    private fun getFocusedField(state: Map<CardField, ICardFieldState>) : CardField? {
        state.forEach {
            if (it.value.isFocused) {
                return it.key
            }
        }

        return null
    }

    companion object {
        const val FocusDelayMs = 350L
    }
}