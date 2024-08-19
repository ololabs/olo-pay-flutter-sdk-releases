package com.olo.flutter.olo_pay_sdk.utils

import io.flutter.Log

enum class LogLevel(val intValue: Int) {
    Assert(Log.ASSERT),
    Debug(Log.DEBUG),
    Error(Log.ERROR),
    Info(Log.INFO),
    Verbose(Log.VERBOSE),
    Warn(Log.WARN)
}

class OloPayLog {
    companion object {
        val OloPayTag = "OloPaySDK: Flutter"

        fun setLogLevel(level: LogLevel) {
            Log.setLogLevel(level.intValue)
        }

        fun println(message: String, level: LogLevel = LogLevel.Debug, tag: String = OloPayTag) {
            Log.println(level.intValue, tag, message)
        }

        fun v(message: String, tag: String = OloPayTag) {
            Log.v(tag, message)
        }

        fun i(message: String, tag: String = OloPayTag) {
            Log.i(tag, message)
        }

        fun d(message: String, tag: String = OloPayTag) {
            Log.d(tag, message)
        }

        fun d(message: String, tr: Throwable, tag: String = OloPayTag) {
            Log.d(tag, message, tr)
        }

        fun w(message: String, tag: String = OloPayTag) {
            Log.w(tag, message)
        }

        fun w(message: String, tr: Throwable, tag: String = OloPayTag) {
            Log.w(tag, message, tr)
        }

        fun e(message: String, tag: String = OloPayTag) {
            Log.e(tag, message)
        }

        fun e(message: String, tr: Throwable, tag: String = OloPayTag) {
            Log.e(tag, message, tr)
        }

        fun wtf(message: String, tag: String = OloPayTag) {
            Log.wtf(tag, message)
        }

        fun wtf(message: String, tr: Throwable, tag: String = OloPayTag) {
            Log.wtf(tag, message, tr)
        }

        fun getStackTrace(tr: Throwable): String {
            return Log.getStackTraceString(tr)
        }
    }
}