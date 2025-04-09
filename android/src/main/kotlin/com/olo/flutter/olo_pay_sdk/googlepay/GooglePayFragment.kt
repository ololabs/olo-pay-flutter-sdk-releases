// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.googlepay

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import com.olo.olopay.googlepay.GooglePayConfig
import com.olo.olopay.googlepay.GooglePayEnvironment
import com.olo.olopay.googlepay.GooglePayResult
import com.olo.olopay.googlepay.GooglePayLauncher
import com.olo.olopay.googlepay.GooglePayReadyCallback
import com.olo.olopay.googlepay.GooglePayResultCallback
import com.olo.olopay.googlepay.GooglePayCheckoutStatus
import com.olo.olopay.googlepay.GooglePayLineItem
import io.flutter.plugin.common.MethodChannel

class GooglePayFragment : Fragment() {
    private var _isReady = false
    private var _googlePayLauncher: GooglePayLauncher? = null
    private var _promise: MethodChannel.Result? = null

    val configuration: GooglePayConfig?
        get() = requireArguments().getParcelable(ConfigurationKey) as GooglePayConfig?

    var resultCallback: FlutterGooglePayResultCallback? = null

    private var _readyCallback: GooglePayReadyCallback? = null
    var readyCallback: GooglePayReadyCallback?
        get() = _readyCallback
        set(callback) {
            _readyCallback = callback
            if (isReady)
                onGooglePayReady(isReady)
        }

    init {
        arguments = Bundle()
    }

    val isReady: Boolean
        get() = _isReady

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        return FrameLayout(requireActivity()).also {
            it.visibility = View.GONE
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        // If google pay config wasn't set by now, create a temporary dummy config
        val config = configuration ?: GooglePayConfig(
            environment = GooglePayEnvironment.Production,
            companyName = "",
            companyCountryCode = ""
        )

        _googlePayLauncher = GooglePayLauncher(this, config, ::onGooglePayReady, null)
    }

    fun setConfiguration(newConfig: GooglePayConfig) {
        requireArguments().putParcelable(ConfigurationKey, newConfig)

        _googlePayLauncher?.let {
            it.config = newConfig
        }
    }

    fun present(
        amount: Int,
        checkoutStatus: GooglePayCheckoutStatus,
        totalPriceLabel: String?,
        listItems: List<GooglePayLineItem>?,
        validateLineItems: Boolean,
        promise: MethodChannel.Result,
    ) {
        _promise = promise
        _googlePayLauncher?.resultCallback = GooglePayResultCallback { result -> onGooglePayResult(result) }
        _googlePayLauncher?.present(amount, checkoutStatus, totalPriceLabel, listItems, validateLineItems)
    }

    private fun onGooglePayResult(result: GooglePayResult) {
        if (_promise != null)
            resultCallback?.onResult(result, _promise!!)
    }

    private fun onGooglePayReady(isReady: Boolean) {
        _isReady = isReady
        readyCallback?.onReady(_isReady)
    }

    companion object {
        const val Tag = "com.olo.flutter.olo_pay_sdk.GooglePayFragment"
        private const val ConfigurationKey = "${Tag}.Configuration"
    }
}

fun interface FlutterGooglePayResultCallback {
    fun onResult(result: GooglePayResult, promise: MethodChannel.Result)
}