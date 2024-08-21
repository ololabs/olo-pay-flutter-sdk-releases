// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.extensions

import kotlinx.coroutines.sync.Semaphore

fun Semaphore.safeRelease() {
    if (this.availablePermits == 0) {
        this.release()
    }
}