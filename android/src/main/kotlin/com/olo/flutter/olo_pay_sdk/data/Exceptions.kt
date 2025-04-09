// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk.data

import java.lang.RuntimeException

class MissingKeyException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class NullValueException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class UnexpectedTypeException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)

class EmptyValueException(
    message: String,
    exception: Throwable? = null
): RuntimeException(message, exception)
