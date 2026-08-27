// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.controls.singleline

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class PaymentCardDetailsSingleLineViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(
    StandardMessageCodec.INSTANCE
) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return PaymentCardDetailsSingleLineView(context, messenger, viewId, creationParams)
    }
}