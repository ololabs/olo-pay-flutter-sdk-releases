// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.utils

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

fun backgroundOperation(operation: suspend() -> Unit) {
    CoroutineScope(Dispatchers.IO).launch {
        operation()
    }
}

fun uiOperation(operation: suspend() -> Unit) {
    CoroutineScope(Dispatchers.Main).launch {
        operation()
    }
}