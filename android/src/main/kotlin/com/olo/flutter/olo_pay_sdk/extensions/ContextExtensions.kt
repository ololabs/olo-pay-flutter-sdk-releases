package com.olo.flutter.olo_pay_sdk.extensions

import android.app.Activity
import android.content.Context
import android.content.ContextWrapper

fun Context.getActivity(): Activity? {
    if (this is ContextWrapper) {
        if (this is Activity) {
            return this
        }

        return baseContext.getActivity()
    }

    return null
}