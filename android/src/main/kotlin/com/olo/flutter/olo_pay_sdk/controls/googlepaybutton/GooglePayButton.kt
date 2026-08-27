// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.controls.googlepaybutton

import android.annotation.SuppressLint
import android.content.Context
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.View.OnClickListener
import com.olo.flutter.olo_pay_sdk.R
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.flutter.olo_pay_sdk.extensions.dpToPx
import com.olo.olopay.googlepay.GooglePayButton
import com.olo.olopay.googlepay.GooglePayButtonTheme
import com.olo.olopay.googlepay.GooglePayButtonType
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

@SuppressLint("InflateParams")
internal class GooglePayButton(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    args: Any?
): PlatformView, MethodChannel.MethodCallHandler, OnClickListener {
    private var googlePayButton: GooglePayButton = LayoutInflater.from(context).inflate(
        R.layout.flutter_olopay_googlepay_button,
        null
    ) as GooglePayButton

    private val methodChannel: MethodChannel
    private var googlePayButtonTheme: GooglePayButtonTheme? = null
    private var googlePayButtonType: GooglePayButtonType? = null
    private var googlePayButtonCornerRadius: Int? = null

    init {
        googlePayButton.setOnClickListener(this)
        loadCustomArgs(args)

        methodChannel = MethodChannel(messenger, DataKeys.DigitalWalletButtonBaseMethodChannelKey + id)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return googlePayButton
    }

    override fun dispose() {}

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when(methodCall.method) {
            DataKeys.RefreshUiMethod -> refreshUI(methodCall, result)
            else -> result.notImplemented()
        }
    }

    override fun onClick(view: View?) {
        methodChannel.invokeMethod(DataKeys.DigitalWalletButtonClickedEventHandlerKey, null)
    }

    private fun refreshUI(call: MethodCall, result: MethodChannel.Result) {
        call.argument<Any>(DataKeys.CreationParameters)?.let { params ->
            loadCustomArgs(params)
        }
        result.success(null)
    }

    private fun loadCustomArgs(args: Any?) {
        val widgetArgs = args as? Map<*, *> ?: return
        val displayMetrics = googlePayButton.context.resources.displayMetrics

        val themeStr =
            (widgetArgs[DataKeys.GooglePayButtonThemeKey] as? String) ?:
            DataKeys.GooglePayButtonThemeDark
        val theme = GooglePayButtonTheme.Companion.convertFrom(themeStr)

        val typeStr =
            (widgetArgs[DataKeys.GooglePayButtonTypeKey] as? String) ?:
            DataKeys.GooglePayButtonTypeCheckout
        val type = GooglePayButtonType.Companion.convertFrom(typeStr)

        val cornerRadiusPx = (widgetArgs[DataKeys.GooglePayButtonCornerRadiusKey] as? Double)?.let {
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, it.toFloat(), displayMetrics)
        } ?: GooglePayButton.defaultCornerRadiusDp.dpToPx(googlePayButton.context)
        val cornerRadiusInt = cornerRadiusPx.toInt()

        (widgetArgs[DataKeys.EnabledParameterKey] as? Boolean)?.let {
            googlePayButton.isEnabled = it
        }

        if (googlePayButtonTheme == theme &&
            googlePayButtonType == type &&
            googlePayButtonCornerRadius == cornerRadiusInt
        ) {
            return
        }

        googlePayButtonTheme = theme
        googlePayButtonType = type
        googlePayButtonCornerRadius = cornerRadiusInt

        googlePayButton.updateButton(
            theme,
            type,
            cornerRadiusInt
        )
    }
}