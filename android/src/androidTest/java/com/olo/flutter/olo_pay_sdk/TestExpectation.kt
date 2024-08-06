// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import kotlinx.coroutines.delay
import org.junit.Assert

class TestExpectation(
    private val intervalMs: Long = 100,
    private val timeoutMs: Long = 5000, //This extra-long timeout seems to be needed for tests in Github Actions to succeed
    private val failMessage: String = "Expectation not fulfilled"
) {
    private var finished = false
    private var elapsedTimeMs: Long = 0

    suspend fun wait() {
        while (!finished && elapsedTimeMs <= timeoutMs) {
            delay(intervalMs)
            elapsedTimeMs += intervalMs
        }

        if (!finished) {
            Assert.fail(failMessage)
        }

        return
    }

    fun fulfill() {
        finished = true
    }

    fun reset() {
        elapsedTimeMs = 0
        finished = false
    }
}