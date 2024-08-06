// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.controls.cvv

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Typeface
import android.os.Build
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import com.olo.flutter.olo_pay_sdk.R
import com.olo.flutter.olo_pay_sdk.data.CustomErrorMessages
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.extensions.oloError
import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.olopay.api.OloPayAPI
import com.olo.flutter.olo_pay_sdk.data.GlobalConstants
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.utils.OloPayLog
import com.olo.olopay.controls.PaymentCardCvvView as OloPayCvvView
import com.olo.olopay.controls.callbacks.CvvInputListener
import com.olo.olopay.data.CardField
import com.olo.olopay.data.ICardFieldState
import com.olo.olopay.exceptions.OloPayException
import io.flutter.FlutterInjector
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@SuppressLint("InflateParams")
internal class PaymentCardCvvView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    args: Any?
) : PlatformView, MethodChannel.MethodCallHandler, CvvInputListener {
    private var cvvInputView: OloPayCvvView
    private val methodChannel: MethodChannel
    private val defaultFont: Typeface
    private var _customErrorMessages: CustomErrorMessages? = null

    init {
        cvvInputView = LayoutInflater.from(context).inflate(
            R.layout.flutter_olopay_cvv_view,
            null
        ) as OloPayCvvView

        cvvInputView.displayErrors = false
        cvvInputView.cvvInputListener = this

        defaultFont = cvvInputView.getFont()
        loadCustomArgs(args)

        methodChannel = MethodChannel(messenger, DataKeys.CvvBaseMethodChannelKey + id)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return cvvInputView
    }

    override fun dispose() {}

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when(methodCall.method) {
            DataKeys.CreateCvvUpdateTokenKey -> createCvvUpdateToken(result)
            DataKeys.GetStateMethodKey -> getState(result)
            DataKeys.IsValidMethodKey -> isValid(result)
            DataKeys.SetEnabledMethodKey -> setEnabled(methodCall, result)
            DataKeys.IsEnabledMethodKey -> isEnabled(result)
            DataKeys.HasErrorMessageMethodKey -> hasErrorMessage(methodCall, result)
            DataKeys.GetErrorMessageMethodKey -> getErrorMessage(methodCall, result)
            DataKeys.ClearFieldsMethodKey -> clear(result)
            DataKeys.RequestFocusMethodKey -> requestFocus(result)
            DataKeys.ClearFocusMethodKey -> clearFocus(result)
            DataKeys.RefreshUiMethod -> refreshUI(methodCall, result)
            else -> result.notImplemented()
       }
    }

    override fun onInputChanged(state: ICardFieldState) {
        val args = mapOf(
            DataKeys.FieldStatesParameterKey to state.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnInputChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    override fun onValidStateChanged(state: ICardFieldState) {
        val args = mapOf(
            DataKeys.FieldStatesParameterKey to state.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnValidStateChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    override fun onFocusChange(state: ICardFieldState) {
        val args = mapOf(
            DataKeys.FieldStatesParameterKey to state.toMap()
        )

        methodChannel.invokeMethod(DataKeys.OnFocusChangedEventHandlerKey, args)
        emitErrorMessage()
    }

    private fun emitErrorMessage() {
        methodChannel.invokeMethod(DataKeys.OnErrorMessageChangedEventHandlerKey, getErrorMessage(true))
    }

    private fun createCvvUpdateToken(result: MethodChannel.Result) {
        if (!cvvInputView.isValid) {
            val errorCode = ErrorCodes.InvalidCvv
            val errorMessage = getErrorMessage(false)
            result.oloError(errorCode, errorMessage)
            return
        }

        CoroutineScope(Dispatchers.IO).launch {
            val params = cvvInputView.cvvTokenParams!!

            try {
                val cvvUpdateToken = OloPayAPI().createCvvUpdateToken(cvvInputView.context, params)
                result.success(cvvUpdateToken.toMap())
            } catch(e: OloPayException) {
                result.oloError(e)
            }
        }
    }

    private fun getState(result: MethodChannel.Result) {
        result.success(cvvInputView.fieldState.toMap())
    }

    private fun isValid(result: MethodChannel.Result) {
        result.success(cvvInputView.isValid)
    }

    private fun setEnabled(call: MethodCall, result: MethodChannel.Result) {
        cvvInputView.isEnabled = try {
            call.getArgOrErrorResult<Boolean>(
                DataKeys.EnabledParameterKey,
                "Unable to set enabled state",
                result
            )
        } catch (_: Exception) {
            return
        }

        result.success(null)
    }

    private fun isEnabled(result: MethodChannel.Result) {
        result.success(cvvInputView.isEnabled)
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

        result.success(cvvInputView.hasErrorMessage(ignoreUneditedFields))
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
        if(cvvInputView.isValid || !cvvInputView.hasErrorMessage(ignoreUneditedFields)) {
            return ""
        }

        val defaultErrorMessage = cvvInputView.getErrorMessage(ignoreUneditedFields)
        return _customErrorMessages?.getCustomErrorMessage(
            ignoreUneditedFields,
            mapOf(CardField.Cvv to cvvInputView.fieldState),
            null
        ) ?: defaultErrorMessage
    }

    private fun clear(result: MethodChannel.Result) {
        cvvInputView.clear()
        result.success(null)
    }

    private fun requestFocus(result: MethodChannel.Result) {
        cvvInputView.requestFocus(true)
        result.success(null)
    }

    private fun clearFocus(result: MethodChannel.Result) {
        cvvInputView.clearFocus()
        result.success(null)
    }

    private fun refreshUI(call: MethodCall, result: MethodChannel.Result) {
        call.argument<Any>(DataKeys.CreationParameters)?.let { params ->
            loadCustomArgs(params)
        }
        result.success(null)
    }

    private fun loadCustomArgs(args: Any?) {
        val widgetArgs = args as? Map<*, *> ?: return

        val hints = widgetArgs[DataKeys.HintsArgumentKey] as? Map<*, *>
        if (hints != null && hints.isNotEmpty()) {
            (hints[CardField.Cvv.toString()] as? String)?.also { cvvHint ->
                cvvInputView.setHintText(cvvHint)
            }
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

        (widgetArgs[DataKeys.TextAlignmentKey] as? String?).let {
            val position = when(it) {
                DataKeys.GravityCenterKey -> Gravity.CENTER
                DataKeys.GravityRightKey -> Gravity.RIGHT or Gravity.CENTER_VERTICAL
                else -> Gravity.LEFT or Gravity.CENTER_VERTICAL
            }

            cvvInputView.setGravity(position)
        }
    }

    private fun loadTextStyles(textStyles: Map<*, *>) {
        if(Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            val textColor = textStyles[DataKeys.TextColorKey] as? String
            if (!textColor.isNullOrBlank()) {
                cvvInputView.setTextColor(textColor)
            }

            val errorTextColor = textStyles[DataKeys.ErrorTextColorKey] as? String
            if (!errorTextColor.isNullOrBlank()) {
                cvvInputView.setErrorTextColor(errorTextColor)
            }

            val hintTextColor = textStyles[DataKeys.HintTextColorKey] as? String
            if (!hintTextColor.isNullOrBlank()) {
                cvvInputView.setHintTextColor(hintTextColor)
            }
        }

        val cursorColor = textStyles[DataKeys.CursorColorKey] as? String
        if (!cursorColor.isNullOrBlank() && Build.VERSION.SDK_INT >= GlobalConstants.ApiQuinceTart) {
            cvvInputView.setCursorColor(cursorColor)
        }

        (textStyles[DataKeys.TextSizeKey] as? Double)?.let {
            cvvInputView.setTextSize(it.toFloat())
        }

        val fontAsset = textStyles[DataKeys.FontAssetKey] as? String
        if(!fontAsset.isNullOrBlank()) {
            try{
                val assetKey = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(fontAsset)
                val font = Typeface.createFromAsset(cvvInputView.context.assets, assetKey)
                cvvInputView.setFont(font)
            } catch (error: Exception) {
                OloPayLog.e(error.toString())
                cvvInputView.setFont(defaultFont)
            }
        } else if(cvvInputView.getFont() != defaultFont){
            cvvInputView.setFont(defaultFont)
        }
    }

    private fun loadBackgroundStyles(backgroundStyles: Map<*, *>) {
        val displayMetrics = cvvInputView.context.resources.displayMetrics

        //Need to convert from dp values to px values
        val borderWidthPx = (backgroundStyles[DataKeys.BorderWidthKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        val borderRadiusPx = (backgroundStyles[DataKeys.BorderRadiusKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        }

        if (Build.VERSION.SDK_INT >= GlobalConstants.ApiOreo) {
            cvvInputView.setCvvBackgroundStyle(
                backgroundColorHex = backgroundStyles[DataKeys.BackgroundColorKey] as? String,
                borderColorHex = backgroundStyles[DataKeys.BorderColorKey] as? String,
                borderWidthPx = borderWidthPx,
                borderRadiusPx = borderRadiusPx)
        }
    }

    private fun loadPaddingStyles(paddingStyles: Map<*, *>) {
        val displayMetrics = cvvInputView.context.resources.displayMetrics

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

        cvvInputView.setCvvPadding(
            startPx = startPadding,
            endPx = endPadding,
            topPx = topPadding,
            bottomPx = bottomPadding
        )
    }
}