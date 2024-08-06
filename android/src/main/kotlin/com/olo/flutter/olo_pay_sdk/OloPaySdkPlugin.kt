// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import PaymentCardCvvViewFactory
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.VisibleForTesting
import androidx.fragment.app.FragmentManager
import com.olo.flutter.olo_pay_sdk.controls.singleline.PaymentCardDetailsSingleLineViewFactory
import com.olo.flutter.olo_pay_sdk.data.DataKeys
import com.olo.flutter.olo_pay_sdk.data.ErrorCodes
import com.olo.flutter.olo_pay_sdk.extensions.getArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.getStringArgOrErrorResult
import com.olo.flutter.olo_pay_sdk.extensions.oloError
import com.olo.flutter.olo_pay_sdk.extensions.safeRelease
import com.olo.flutter.olo_pay_sdk.extensions.toMap
import com.olo.flutter.olo_pay_sdk.googlepay.FlutterGooglePayResultCallback
import com.olo.flutter.olo_pay_sdk.googlepay.GooglePayFragment
import com.olo.flutter.olo_pay_sdk.utils.MethodFinishedCallback
import com.olo.flutter.olo_pay_sdk.utils.OloPayLog
import com.olo.flutter.olo_pay_sdk.utils.backgroundOperation
import com.olo.flutter.olo_pay_sdk.utils.uiOperation
import com.olo.olopay.api.IOloPayApiInitializer
import com.olo.olopay.api.OloPayApiInitializer
import com.olo.olopay.data.OloPayEnvironment
import com.olo.olopay.data.SdkWrapperInfo
import com.olo.olopay.data.SdkWrapperPlatform
import com.olo.olopay.data.SdkBuildType
import com.olo.olopay.data.SetupParameters
import com.olo.olopay.googlepay.Config
import com.olo.olopay.googlepay.Environment
import com.olo.olopay.googlepay.ReadyCallback
import com.olo.olopay.googlepay.Result
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import io.flutter.plugin.common.MethodChannel.Result as FlutterResult
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import kotlinx.coroutines.withContext
import java.lang.Exception

/** OloPaySdkPlugin */
class OloPaySdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private var activityBinding: ActivityPluginBinding? = null

  @VisibleForTesting
  internal lateinit var appContext: Context
  @VisibleForTesting
  internal var onMethodCallFinished: MethodFinishedCallback? = null
  @VisibleForTesting
  internal val environment
    get() = IOloPayApiInitializer.environment

  private val fragmentManager: FragmentManager?
    get() {
      (activityBinding?.activity as? FlutterFragmentActivity)?.let {
        return it.supportFragmentManager
      }

      return null
    }

  private var _sdkInitializingSemaphore = Semaphore(1)
  private var _sdkInitializedSemaphore = Semaphore(1)
  private var _googlePaySemaphore = Semaphore(1)
  private var _googlePayReadySemaphore = Semaphore(1)
  private var _googlePayInitializedSemaphore = Semaphore(1)
  private var _metadataInitialized = false

  //WARNING: DO NOT ACCESS OR MODIFY THESE DIRECTLY... USE THREAD-SAFE GETTERS/SETTERS
  @VisibleForTesting
  internal var _sdkInitialized = false
  @VisibleForTesting
  internal var _googlePayReady = false

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, DataKeys.OloPaySdkMethodChannelKey)
    channel.setMethodCallHandler(this)
    appContext = flutterPluginBinding.applicationContext

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        DataKeys.PaymentCardDetailsSingleLineViewKey,
        PaymentCardDetailsSingleLineViewFactory(flutterPluginBinding.binaryMessenger)
      )

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        DataKeys.PaymentCardCvvViewKey,
        PaymentCardCvvViewFactory(flutterPluginBinding.binaryMessenger)
      )
  }

  override fun onMethodCall(call: MethodCall, result: FlutterResult) {
    when (call.method) {
      DataKeys.InitializeOloPayMethodKey -> initializeOloPay(call, result)
      DataKeys.InitializeMetadataMethodKey -> initializeMetadata(call, result)
      DataKeys.IsInitializedMethodKey -> isSdkInitialized(result)
      DataKeys.IsDigitalWalletReadyMethodKey -> isGooglePayReady(result)
      DataKeys.InitializeGooglePayMethodKey -> initializeGooglePay(call, result)
      DataKeys.ChangeGooglePayVendorMethodKey -> changeGooglePayVendor(call, result)
      DataKeys.CreateDigitalWalletPaymentMethod -> getDigitalWalletPaymentMethod(call, result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
    verifyActivity()
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
    verifyActivity()
  }

  override fun onDetachedFromActivity() {
    activityBinding = null
  }

  private fun verifyActivity(): Boolean {
    if (activityBinding?.activity as? FlutterFragmentActivity == null) {
      OloPayLog.w("Not using FlutterFragmentActivity. Some aspects of the Olo Pay SDK will not be available.")
      return false;
    }

    return true;
  }

  private fun initializeOloPay(call: MethodCall, result: FlutterResult) = backgroundOperation {
    _sdkInitializingSemaphore.withPermit {
      setSdkInitialized(false)

      val productionEnv = try {
        call.getArgOrErrorResult(
          DataKeys.ProductionEnvironmentKey,
          DefaultProductionEnvironment,
          "Unable to initialize OloPaySdk",
          result
        )
      } catch (_: Exception) {
        onMethodCallFinished?.invoke()
        return@backgroundOperation
      }

      val params = SetupParameters(
        if (productionEnv) OloPayEnvironment.Production else OloPayEnvironment.Test
      )

      val initializer = OloPayApiInitializer()
      initializer.setup(appContext, params)
      setSdkInitialized(true)

      withContext(Dispatchers.Main) {
        result.success(null)
        onMethodCallFinished?.invoke()
      }
    }
  }

  private fun initializeMetadata(call: MethodCall, result: FlutterResult) {
    // First call happens while the plugin is getting initialized... Subsequent calls should be ignored
    if (_metadataInitialized) {
      result.success(null)
      onMethodCallFinished?.invoke()
      return
    }

    val baseError = "Unable to initialize metadata"

    val hybridVersion = try {
      call.getStringArgOrErrorResult(
        DataKeys.HybridSdkVersionKey,
        DefaultVersionString,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return
    }

    val hybridBuildType = try {
      call.getStringArgOrErrorResult(
        DataKeys.HybridBuildTypeKey,
        DataKeys.HybridBuildTypeInternalValue,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return
    }

    setSdkWrapperInfo(hybridVersion, hybridBuildType)
    _metadataInitialized = true
    result.success(null)
    onMethodCallFinished?.invoke()
  }

  private fun initializeGooglePay(call: MethodCall, result: MethodChannel.Result) = googlePayLockingOperation {
    val baseError = "Unable to initialize Google Pay"

    if (!isSdkInitialized()) {
      result.oloError(
        ErrorCodes.UninitializedSdk,
        "${baseError}: Olo Pay SDK has not been initialized"
      )
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val countryCode = try {
      call.getStringArgOrErrorResult(
        DataKeys.DigitalWalletCountryCodeParameterKey,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val merchantName = try {
      call.getStringArgOrErrorResult(
        DataKeys.GPayMerchantNameKey,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val productionEnv = try {
      call.getArgOrErrorResult(
        DataKeys.GPayProductionEnvironmentKey,
        DefaultGooglePayProductionEnvironment,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val fullAddressFormat = try {
      call.getArgOrErrorResult(
        DataKeys.GPayFullAddressFormatKey,
        DefaultFullAddressFormat,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val existingPaymentMethodRequired = try {
      call.getArgOrErrorResult(
        DataKeys.GPayExistingPaymentMethodRequiredKey,
        DefaultExistingPaymentMethodRequired,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val emailRequired = try {
      call.getArgOrErrorResult(
        DataKeys.GPayEmailRequiredKey,
        DefaultEmailRequired,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val phoneNumberRequired = try {
      call.getArgOrErrorResult(
        DataKeys.GPayPhoneNumberRequiredKey,
        DefaultPhoneNumberRequired,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val appMetadata = appContext.packageManager.getApplicationInfo(
      appContext.packageName,
      PackageManager.GET_META_DATA
    ).metaData

    if (!appMetadata.containsKey("com.google.android.gms.wallet.api.enabled")) {
      result.oloError(
        ErrorCodes.InvalidGooglePaySetup,
        "${baseError}: AndroidManifest missing com.google.android.gms.wallet.api.enabled entry"
      )
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    // Moved here for testing purposes - We cannot test anything beyond this point due to testing limitations
    if (!verifyActivity()) {
      val message = "${baseError}: App must use FlutterFragmentActivity - https://tinyurl.com/yfwr5raa"
      result.oloError(ErrorCodes.InvalidGooglePaySetup, message)

      return@googlePayLockingOperation
    }

    // Clean up in case digital wallets have been initialized multiple times
    initializeGooglePay(null)
    removeGooglePayFragment()

    val googlePayConfig = Config(
      if (productionEnv) Environment.Production else Environment.Test,
      merchantName,
      countryCode,
      existingPaymentMethodRequired,
      emailRequired,
      phoneNumberRequired,
      if (fullAddressFormat) Config.AddressFormat.Full else Config.AddressFormat.Min
    )

    initializeGooglePay(googlePayConfig)
    changeDigitalWalletCountry(countryCode, merchantName)
    result.success(null)
  }

  private fun changeGooglePayVendor(call: MethodCall, result: MethodChannel.Result) = googlePayLockingOperation {
    val baseError = "Unable to change Google Pay Country"

    if (!isSdkInitialized()) {
      result.oloError(
        ErrorCodes.UninitializedSdk,
        "${baseError}: Olo Pay SDK has not been initialized"
      )
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val countryCode = try {
      call.getStringArgOrErrorResult(
        DataKeys.DigitalWalletCountryCodeParameterKey,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    val merchantName = try {
      call.getStringArgOrErrorResult(
        DataKeys.GPayMerchantNameKey,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    // We cannot test anything beyond this point due to testing limitations
    if (getGooglePayFragment() == null) {
      result.oloError(
        ErrorCodes.GooglePayUninitialized,
        "${baseError}: Google Pay not initialized"
      )
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    changeDigitalWalletCountry(countryCode, merchantName)
    result.success(null)
  }

  private fun getDigitalWalletPaymentMethod(call: MethodCall, result: MethodChannel.Result) = uiOperation {
    // Unable to use googlePayLockingOperation because this call waits for a callback method... we need to unlock
    // the semaphore manually
    val baseError = "Unable to create payment method"

    if (!isSdkInitialized()) {
      result.oloError(
        ErrorCodes.UninitializedSdk,
        "${baseError}: Olo Pay SDK has not been initialized"
      )
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    val amount = try {
      call.getArgOrErrorResult<Double>(
        DataKeys.DigitalWalletAmountParameterKey,
        baseError,
        result
      )
    } catch(_: Exception) {
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    if (amount < 0){
      result.oloError(
        ErrorCodes.InvalidParameter,
        "${baseError}: Value for '${DataKeys.DigitalWalletAmountParameterKey}' cannot be negative"
      )
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    val currencyCode = try {
      call.getStringArgOrErrorResult(
        DataKeys.GPayCurrencyCodeKey,
        DefaultCurrencyCode,
        baseError,
        false,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    val currencyMultiplier = try {
      call.getArgOrErrorResult(
        DataKeys.GPayCurrencyMultiplierKey,
        DefaultCurrencyMultiplier,
        baseError,
        result
      )
    } catch (_: Exception) {
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    val amountInSmallestCurrencyUnit = (amount * currencyMultiplier).toInt()

    // Moved here for testing purposes - We cannot test anything beyond this point due to testing limitations
    if (!isGooglePayReady()) {
      result.oloError(
        ErrorCodes.GooglePayNotReady,
        "${baseError}: Google Pay isn't ready yet"
      )
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    _googlePaySemaphore.acquire()

    val fragment = getGooglePayFragment()
    if (fragment == null) {
      result.oloError(
        ErrorCodes.GooglePayUninitialized,
        "${baseError}: Google Pay not initialized"
      )
      _googlePaySemaphore.safeRelease()
      return@uiOperation
    }

    if (!fragment.isReady) {
      val reason = if (fragment.countryCode.isNullOrBlank()) {
        "Google Pay not initialized - country code not set"
      } else if (fragment.merchantName.isNullOrBlank()) {
        "Google Pay not initialized - merchant name not set"
      } else {
        "Google Pay isn't ready yet"
      }

      result.oloError(
        ErrorCodes.GooglePayNotReady,
        "${baseError}: $reason"
      )
      _googlePaySemaphore.safeRelease()
      return@uiOperation
    }

    fragment.resultCallback =
      FlutterGooglePayResultCallback{ result, promise -> onGooglePayResult(result, promise) }

    fragment.present(currencyCode, amountInSmallestCurrencyUnit, result)
  }

  private fun isSdkInitialized(result: FlutterResult) = uiOperation {
    result.success(isSdkInitialized())
    onMethodCallFinished?.invoke()
  }

  private fun isGooglePayReady(result: FlutterResult) = uiOperation {
    result.success(isGooglePayReady())
    onMethodCallFinished?.invoke()
  }

  private suspend fun isSdkInitialized(): Boolean {
    _sdkInitializedSemaphore.withPermit {
      return _sdkInitialized
    }
  }

  private suspend fun setSdkInitialized(initialized: Boolean) {
    _sdkInitializedSemaphore.withPermit {
      _sdkInitialized = initialized
    }
  }

  private suspend fun isGooglePayInitialized(): Boolean {
    _googlePayInitializedSemaphore.withPermit {
      return IOloPayApiInitializer.googlePayConfig != null
    }
  }

  private suspend fun initializeGooglePay(config: Config?) {
    _googlePayInitializedSemaphore.withPermit {
      IOloPayApiInitializer.googlePayConfig = config
    }
  }

  private suspend fun isGooglePayReady() : Boolean {
    _googlePayReadySemaphore.withPermit {
      return _googlePayReady
    }
  }

  private suspend fun setGooglePayReady(ready: Boolean) {
    _googlePayReadySemaphore.withPermit {
      _googlePayReady = ready
    }
  }

  private suspend fun changeDigitalWalletCountry(countryCode: String, merchantName: String) {
    getGooglePayFragment(countryCode, merchantName, true)
  }

  private suspend fun getGooglePayFragment(countryCode: String? = null, merchantName: String? = null, createIfNeeded: Boolean = false): GooglePayFragment? {
    if (!isGooglePayInitialized()) {
      return null
    }

    var fragment = fragmentManager?.findFragmentByTag(GooglePayFragment.Tag) as GooglePayFragment?

    //If the fragment isn't null, determine if we need a new instance
    var forceCreation = false
    if (fragment != null) {
      val invalidCountryCode = !countryCode.isNullOrEmpty() && fragment.countryCode != countryCode
      val invalidMerchantName = !merchantName.isNullOrEmpty() && fragment.merchantName != merchantName

      if (invalidCountryCode || invalidMerchantName) {
        removeGooglePayFragment(fragment)
        fragment = null
        forceCreation = true
      }
    }

    if (fragment == null && (createIfNeeded || forceCreation)) {
      fragment = GooglePayFragment()
      fragment.countryCode = countryCode
      fragment.merchantName = merchantName
      fragmentManager?.beginTransaction()?.add(fragment, GooglePayFragment.Tag)?.commit()
    }

    fragment?.also {
      it.readyCallback = ReadyCallback { isReady -> onGooglePayReady(isReady) }
    }

    return fragment
  }

  private suspend fun removeGooglePayFragment() {
    getGooglePayFragment(createIfNeeded = false)?.let { it ->
      removeGooglePayFragment(it)
    }
  }

  private fun removeGooglePayFragment(fragment: GooglePayFragment) {
    fragmentManager?.beginTransaction()?.remove(fragment)?.commitAllowingStateLoss()
    emitDigitalWalletReadyEvent(false)
  }

  private fun onGooglePayReady(isReady: Boolean) {
    emitDigitalWalletReadyEvent(isReady)
  }

  private fun onGooglePayResult(googlePayResult: Result, promise: MethodChannel.Result) {
    _googlePaySemaphore.safeRelease()

    when (googlePayResult) {
      is Result.Completed -> {
        promise.success(googlePayResult.paymentMethod.toMap())
      }
      is Result.Canceled -> {
        promise.success(null)
      }
      is Result.Failed -> {
        promise.success(googlePayResult.error.toMap())
      }
    }
  }

  private fun emitDigitalWalletReadyEvent(isReady: Boolean) = backgroundOperation {
    if (isGooglePayReady() == isReady) {
      return@backgroundOperation
    }

    setGooglePayReady(isReady)
    withContext(Dispatchers.Main) {
      val args = mapOf(DataKeys.DigitalWalletReadyParameterKey to isReady)
      channel.invokeMethod(DataKeys.DigitalWalletReadyEventHandlerKey, args)
    }
  }

  private fun googlePayLockingOperation(operation: suspend() -> Unit) {
    CoroutineScope(Dispatchers.Main).launch {
      _googlePaySemaphore.withPermit {
        operation()
      }
    }
  }

  private fun setSdkWrapperInfo(version: String, buildType: String) {
    val versionStrings = version.split(".")

    val wrapperInfo = SdkWrapperInfo(
      (versionStrings.getOrElse(MajorVersionIndex) { "0" }).toIntOrNull() ?: 0,
      (versionStrings.getOrElse(MinorVersionIndex) { "0" }).toIntOrNull() ?: 0,
      (versionStrings.getOrElse(BuildVersionIndex) { "0" }).toIntOrNull() ?: 0,
      when (buildType) {
        DataKeys.HybridBuildTypePublicValue -> SdkBuildType.Public
        else -> SdkBuildType.Internal
      },
      SdkWrapperPlatform.Flutter
    )

    IOloPayApiInitializer.sdkWrapperInfo = wrapperInfo
  }

  companion object {
    // Default Initialization Options
    const val DefaultProductionEnvironment = true

    // Default Google Pay Initialization Options
    const val DefaultGooglePayProductionEnvironment = true
    const val DefaultExistingPaymentMethodRequired = true
    const val DefaultEmailRequired = false
    const val DefaultPhoneNumberRequired = false
    const val DefaultFullAddressFormat = false

    // Default Digital Wallet Payment Method Request Options
    const val DefaultCurrencyMultiplier = 100
    const val DefaultCurrencyCode = "USD"

    const val MajorVersionIndex = 0
    const val MinorVersionIndex = 1
    const val BuildVersionIndex = 2
    const val DefaultVersionString = "0.0.0"
  }
}