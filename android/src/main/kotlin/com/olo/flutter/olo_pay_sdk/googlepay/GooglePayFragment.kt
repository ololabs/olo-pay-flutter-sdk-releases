// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.googlepay

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment
import com.olo.olopay.googlepay.Result
import com.olo.olopay.googlepay.GooglePayContext
import com.olo.olopay.googlepay.ReadyCallback
import com.olo.olopay.googlepay.ResultCallback
import io.flutter.plugin.common.MethodChannel

class GooglePayFragment : Fragment() {
    private var _isReady = false
    private var _googlePayContext: GooglePayContext? = null
    private var _promise: MethodChannel.Result? = null

    var merchantName: String?
        get() = requireArguments().getString(MerchantNameKey, null)
        set(newValue) = requireArguments().putString(MerchantNameKey, newValue)

    var countryCode: String?
        get() = requireArguments().getString(CountryCodeKey, null)
        set(newValue) = requireArguments().putString(CountryCodeKey, newValue)

    var resultCallback: FlutterGooglePayResultCallback? = null

    private var _readyCallback: ReadyCallback? = null
    var readyCallback: ReadyCallback?
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
        _googlePayContext = GooglePayContext(this, ::onGooglePayReady, null, merchantName, countryCode)
    }

    fun present(currencyCode: String, amount: Int, promise: MethodChannel.Result) {
        _promise = promise
        _googlePayContext?.resultCallback = ResultCallback { result -> onGooglePayResult(result) }
        _googlePayContext?.present(currencyCode, amount)
    }

    private fun onGooglePayResult(result: Result) {
        if (_promise != null)
            resultCallback?.onResult(result, _promise!!)
    }

    private fun onGooglePayReady(isReady: Boolean) {
        _isReady = isReady && !countryCode.isNullOrEmpty() && !merchantName.isNullOrEmpty()
        readyCallback?.onReady(_isReady)
    }

    companion object {
        const val Tag = "com.olo.flutter.olo_pay_sdk.GooglePayFragment"
        private const val MerchantNameKey = "${Tag}.MerchantName"
        private const val CountryCodeKey = "${Tag}.CountryCode"
    }
}

fun interface FlutterGooglePayResultCallback {
    fun onResult(result: Result, promise: MethodChannel.Result)
}