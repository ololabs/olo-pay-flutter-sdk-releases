// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
package com.olo.flutter.olo_pay_sdk

import PaymentCardCvvViewFactory
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.VisibleForTesting
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.FragmentManager
import com.olo.flutter.olo_pay_sdk.controls.form.PaymentCardDetailsFormFactory
import com.olo.flutter.olo_pay_sdk.controls.googlepaybutton.GooglePayButtonFactory
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
import com.olo.olopay.data.CurrencyCode
import com.olo.olopay.data.OloPayEnvironment
import com.olo.olopay.data.SdkWrapperInfo
import com.olo.olopay.data.SdkWrapperPlatform
import com.olo.olopay.data.SdkBuildType
import com.olo.olopay.googlepay.GooglePayConfig
import com.olo.olopay.googlepay.GooglePayEnvironment
import com.olo.olopay.googlepay.GooglePayReadyCallback
import com.olo.olopay.googlepay.GooglePayResult
import com.olo.olopay.googlepay.GooglePayCheckoutStatus
import com.olo.olopay.googlepay.GooglePayException
import com.olo.olopay.googlepay.GooglePayLineItem
import com.olo.olopay.googlepay.GooglePayLineItemStatus
import com.olo.olopay.googlepay.GooglePayLineItemType
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
  private var _metadataInitialized = false
  private var _currencyMultiplier = DefaultCurrencyMultiplier
  private var _hasEmittedDigitalWalletReadyEvent = false

  private var _sdkInitializingLock = Semaphore(1)
  private var _sdkInitializedLock = Semaphore(1)
  private var _googlePayLock = Semaphore(1)
  private var _googlePayReadyLock = Semaphore(1)
  private var _googlePayInitializedLock = Semaphore(1)

  private val activity: FragmentActivity?
    get() {
      if (activityBinding == null) {
        OloPayLog.w("Attempting to use activity before being setup by Flutter. Activity binding is null.")
        return null
      }

      val activity = activityBinding?.activity as? FragmentActivity

      val warningMessage = if (activity == null) {
        val message = StringBuilder("Unsupported activity detected: ")
        message.append("Activity instance should inherit from FlutterFragmentActivity or FragmentActivity\n")
        message.append("Some aspects of the Olo Pay SDK will not be available\n")
        message.append("See https://tinyurl.com/yfwr5raa for specifics\n\n")
        message.append("Activity hierarchy: ${getObjectHierarchy(activityBinding!!.activity)}")
        message.toString()
      } else if (activity as? FlutterFragmentActivity == null) {
        val message = StringBuilder("FragmentActivity detected instead of FlutterFragmentActivity\n")
        message.append("In most cases, FlutterFragmentActivity should be used instead of FragmentActivity\n")
        message.append("See https://tinyurl.com/yfwr5raa for specifics\n\n")
        message.append("Activity hierarchy: ${getObjectHierarchy(activity)}")
        message.toString()
      } else {
        null
      }

      warningMessage?.let { warning ->
        OloPayLog.w(warning)
      }

      return activity
    }

  private val fragmentManager: FragmentManager?
    get() = activity?.supportFragmentManager

  @VisibleForTesting
  internal lateinit var appContext: Context
  @VisibleForTesting
  internal var onMethodCallFinished: MethodFinishedCallback? = null
  @VisibleForTesting
  internal val environment
    get() = IOloPayApiInitializer.environment

  //WARNING: DO NOT ACCESS OR MODIFY THESE DIRECTLY... USE THREAD-SAFE GETTERS/SETTERS
  @VisibleForTesting
  internal var _googlePayConfig: GooglePayConfig? = null
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
        DataKeys.PaymentCardDetailsFormViewKey,
        PaymentCardDetailsFormFactory(flutterPluginBinding.binaryMessenger)
      )

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        DataKeys.PaymentCardCvvViewKey,
        PaymentCardCvvViewFactory(flutterPluginBinding.binaryMessenger)
      )

    flutterPluginBinding
      .platformViewRegistry
      .registerViewFactory(
        DataKeys.DigitalWalletButtonViewKey,
        GooglePayButtonFactory(flutterPluginBinding.binaryMessenger)
      )
  }

  override fun onMethodCall(call: MethodCall, result: FlutterResult) {
    when (call.method) {
      DataKeys.InitializeOloPayMethodKey -> initializeOloPay(call, result)
      DataKeys.InitializeMetadataMethodKey -> initializeMetadata(call, result)
      DataKeys.InitializeDigitalWalletMethodKey -> initializeDigitalWallet(call, result)
      DataKeys.IsInitializedMethodKey -> isSdkInitialized(result)
      DataKeys.IsDigitalWalletReadyMethodKey -> isDigitalWalletReady(result)
      DataKeys.UpdateDigitalWalletConfigurationMethodKey -> updateDigitalWalletConfiguration(call, result)
      DataKeys.CreateDigitalWalletPaymentMethod -> createDigitalWalletPaymentMethod(call, result)
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

  fun getObjectHierarchy(obj: Any): String {
    val hierarchy = mutableListOf<String>()
    var currentClass: Class<*>? = obj::class.java

    while (currentClass != null) {
      hierarchy.add(currentClass.name)
      currentClass = currentClass.superclass
    }

    return hierarchy.joinToString("\n -> ")
  }

  private fun verifyActivity(): Boolean {
    return activity != null
  }

  private fun initializeOloPay(call: MethodCall, result: FlutterResult) = backgroundOperation {
    _sdkInitializingLock.withPermit {
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

      val environment =
        if (productionEnv) OloPayEnvironment.Production else OloPayEnvironment.Test

      val initializer = OloPayApiInitializer()
      initializer.setup(appContext, environment)
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

    try {
      val hybridVersion = call.getStringArgOrErrorResult(
        DataKeys.HybridSdkVersionKey,
        DefaultVersionString,
        baseError,
        false,
        result
      )

      val hybridBuildType = call.getStringArgOrErrorResult(
        DataKeys.HybridBuildTypeKey,
        DataKeys.HybridBuildTypeInternalValue,
        baseError,
        false,
        result
      )

      setSdkWrapperInfo(hybridVersion, hybridBuildType)
      _metadataInitialized = true
      result.success(null)
    } catch (_: Exception) {
      return
    } finally {
      onMethodCallFinished?.invoke()
    }
  }

  private fun initializeDigitalWallet(call: MethodCall, result: MethodChannel.Result) {
    updateGooglePayConfiguration(call, result, "Unable to initialize Google Pay")
  }

  private fun updateDigitalWalletConfiguration(call: MethodCall, result: MethodChannel.Result) = googlePayLockingOperation {
    updateGooglePayConfiguration(call, result, "Unable to update the Google Pay configuration")
  }

  private fun createDigitalWalletPaymentMethod(call: MethodCall, result: MethodChannel.Result) = uiOperation {
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

    val amount: Double
    val googlePayCheckoutStatus: String
    val totalPriceLabel: String
    val lineItems: List<GooglePayLineItem>?
    val validateLineItems: Boolean

    try {
      amount = call.getArgOrErrorResult<Double>(
        DataKeys.DigitalWalletAmountParameterKey,
        baseError,
        result
      )

      googlePayCheckoutStatus = call.getStringArgOrErrorResult(
        DataKeys.GPayCheckoutStatusKey,
        baseError,
        false,
        result
      )

      totalPriceLabel = call.getStringArgOrErrorResult(
        DataKeys.GPayTotalPriceLabelKey,
        "",
        baseError,
        true,
        result
      )

      val flutterLineItems = call.getArgOrErrorResult<ArrayList<HashMap<String, Any?>>?>(
        DataKeys.GPayLineItemsKey,
        null,
        baseError,
        result
      )

      lineItems = flutterLineItems?.map { item ->
        GooglePayLineItem(
          item.getStringArgOrErrorResult(DataKeys.LineItemLabelKey, baseError, false, result),
          (item.getArgOrErrorResult<Double>(DataKeys.LineItemAmountKey, baseError, result) * _currencyMultiplier).toInt(),
          GooglePayLineItemType.valueOf(item.getStringArgOrErrorResult(DataKeys.LineItemTypeKey, baseError, false, result)),
          GooglePayLineItemStatus.valueOf(item.getStringArgOrErrorResult(DataKeys.LineItemStatusKey, GooglePayLineItemStatus.Final.name, baseError, false, result))
        )
      }

      validateLineItems = call.getArgOrErrorResult<Boolean>(
        DataKeys.GPayValidateLineItems,
        baseError,
        result
      )
    } catch (e: Exception) {
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    val checkoutStatus = try {
      GooglePayCheckoutStatus.valueOf(googlePayCheckoutStatus)
    } catch (_: Exception) {
      result.oloError(ErrorCodes.InvalidParameter, "$googlePayCheckoutStatus is not a valid parameter")
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

    val amountInSmallestCurrencyUnit = (amount * _currencyMultiplier).toInt()

    // Moved here for testing purposes - We cannot test anything beyond this point due to testing limitations
    if (!isGooglePayInitialized()) {
      result.oloError(
        ErrorCodes.DigitalWalletUninitialized,
        "${baseError}: Google Pay has not been initialized"
      )
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    if (!isGooglePayReady()) {
      result.oloError(
        ErrorCodes.DigitalWalletNotReady,
        "${baseError}: Google Pay isn't ready yet"
      )
      onMethodCallFinished?.invoke()
      return@uiOperation
    }

    _googlePayLock.acquire()

    val fragment = getGooglePayFragment()
    if (fragment == null) {
      result.oloError(
        ErrorCodes.UnexpectedError,
        "${baseError}: An unexpected error occurred"
      )
      _googlePayLock.safeRelease()
      return@uiOperation
    }

    if (!fragment.isReady) {
      val reason = if (fragment.configuration == null) {
        "Google Pay not initialized"
      } else {
        "Google Pay isn't ready yet"
      }

      result.oloError(
        ErrorCodes.DigitalWalletNotReady,
        "${baseError}: $reason"
      )
      _googlePayLock.safeRelease()
      return@uiOperation
    }

    fragment.resultCallback =
      FlutterGooglePayResultCallback{ result, promise -> onGooglePayResult(result, promise) }

    try {
      fragment.present(amountInSmallestCurrencyUnit, checkoutStatus, totalPriceLabel, lineItems, validateLineItems, result)
    } catch (e: GooglePayException) {
      result.oloError(
        e.errorType.name,
        "${baseError}: ${e.message}"
      )
      _googlePayLock.safeRelease()
      return@uiOperation
    } catch (e: Exception) {
      result.oloError(
        ErrorCodes.UnexpectedError,
        "${baseError}: An unexpected error occurred"
      )
      _googlePayLock.safeRelease()
      return@uiOperation
    }
  }

  private fun isSdkInitialized(result: FlutterResult) = uiOperation {
    result.success(isSdkInitialized())
    onMethodCallFinished?.invoke()
  }

  private fun isDigitalWalletReady(result: FlutterResult) = uiOperation {
    result.success(isGooglePayReady())
    onMethodCallFinished?.invoke()
  }

  private fun getGooglePayConfiguration(
    call: MethodCall,
    result: MethodChannel.Result,
    baseError: String
  ): GooglePayConfig? {
    try {
      val productionEnv = call.getArgOrErrorResult(
        DataKeys.GPayProductionEnvironmentKey,
        DefaultGooglePayProductionEnvironment,
        baseError,
        result
      )

      val countryCode = call.getStringArgOrErrorResult(
        DataKeys.DigitalWalletCountryCodeParameterKey,
        baseError,
        false,
        result
      )

      val currencyCodeString = call.getStringArgOrErrorResult(
        DataKeys.GPayCurrencyCodeKey,
        DefaultCurrencyCode,
        baseError,
        true,
        result
      )

      val currencyCode = try {
        CurrencyCode.valueOf(currencyCodeString.uppercase())
      } catch (_: Exception) {
        result.oloError(ErrorCodes.UnexpectedParameterType, "${baseError}: $currencyCodeString is not supported")
        return null
      }

      val merchantName = call.getStringArgOrErrorResult(
        DataKeys.GPayMerchantNameKey,
        baseError,
        false,
        result
      )

      val existingPaymentMethodRequired = call.getArgOrErrorResult(
        DataKeys.GPayExistingPaymentMethodRequiredKey,
        DefaultExistingPaymentMethodRequired,
        baseError,
        result
      )

      val emailRequired = call.getArgOrErrorResult(
        DataKeys.GPayEmailRequiredKey,
        DefaultEmailRequired,
        baseError,
        result
      )

      val phoneNumberRequired = call.getArgOrErrorResult(
        DataKeys.GPayPhoneNumberRequiredKey,
        DefaultPhoneNumberRequired,
        baseError,
        result
      )

      val fullBillingAddressRequired = call.getArgOrErrorResult(
        DataKeys.GPayFullBillingAddressRequiredKey,
        DefaultFullBillingAddressRequired,
        baseError,
        result
      )

      val fullNameRequired = call.getArgOrErrorResult(
        DataKeys.GPayFullNameRequiredKey,
        DefaultFullNameRequired,
        baseError,
        result
      )

      _currencyMultiplier = call.getArgOrErrorResult(
        DataKeys.GPayCurrencyMultiplierKey,
        DefaultCurrencyMultiplier,
        baseError,
        result
      )

      return GooglePayConfig(
        if (productionEnv) GooglePayEnvironment.Production else GooglePayEnvironment.Test,
        merchantName,
        countryCode,
        existingPaymentMethodRequired,
        emailRequired,
        phoneNumberRequired,
        fullNameRequired,
        fullBillingAddressRequired,
        currencyCode
      )
    } catch (_: Exception) {
      return null
    }
  }

  private fun updateGooglePayConfiguration(
    call: MethodCall,
    result: MethodChannel.Result,
    baseError: String
  ) = googlePayLockingOperation {
    if (!isSdkInitialized()) {
      result.oloError(
        ErrorCodes.UninitializedSdk,
        "${baseError}: Olo Pay SDK has not been initialized"
      )
      onMethodCallFinished?.invoke()
      return@googlePayLockingOperation
    }

    // If the configuration comes back null that means an error was reported, so we need to return
    val newConfiguration = getGooglePayConfiguration(call, result, baseError)

    if (newConfiguration == null) {
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
      val message = StringBuilder("${baseError}: App must use FlutterFragmentActivity or FragmentActivity\n")
      message.append("See https://tinyurl.com/yfwr5raa for specifics")
      result.oloError(ErrorCodes.InvalidGooglePaySetup, message.toString())
      return@googlePayLockingOperation
    }

    val fragment = getGooglePayFragment()
    if (fragment == null) {
      val message = "${baseError}: Unexpected error occurred"
      result.oloError(ErrorCodes.UnexpectedError, message)
      return@googlePayLockingOperation
    }

    updateGooglePayConfig(newConfiguration)
    fragment.readyCallback = GooglePayReadyCallback { isReady -> onGooglePayReady(isReady) }
    fragment.setConfiguration(newConfiguration)

    result.success(null)
  }

  private suspend fun isSdkInitialized(): Boolean {
    _sdkInitializedLock.withPermit {
      return _sdkInitialized
    }
  }

  private suspend fun setSdkInitialized(initialized: Boolean) {
    val previousState = isGooglePayReady()

    _sdkInitializedLock.withPermit {
      _sdkInitialized = initialized
    }

    emitDigitalWalletReadyEvent(previousState)
  }

  private suspend fun isGooglePayInitialized(): Boolean {
    _googlePayInitializedLock.withPermit {
      return _googlePayConfig != null
    }
  }

  private suspend fun updateGooglePayConfig(config: GooglePayConfig?) {
    val previousState = isGooglePayReady()

    _googlePayInitializedLock.withPermit {
      _googlePayConfig = config
    }

    emitDigitalWalletReadyEvent(previousState)
  }

  private suspend fun isGooglePayReady() : Boolean {
    _googlePayReadyLock.withPermit {
      return isSdkInitialized() && isGooglePayInitialized() && _googlePayReady
    }
  }

  private fun setGooglePayReady(ready: Boolean) = backgroundOperation {
    val previousState = isGooglePayReady()

    _googlePayReadyLock.withPermit {
      _googlePayReady = ready
    }

    emitDigitalWalletReadyEvent(previousState)
  }

  private fun getGooglePayFragment(): GooglePayFragment? {
    val fragMgr = fragmentManager ?: return null
    var fragment = fragMgr.findFragmentByTag(GooglePayFragment.Tag) as GooglePayFragment?

    if (fragment == null) {
      fragment = GooglePayFragment()
      fragMgr.beginTransaction().add(fragment, GooglePayFragment.Tag).commit()
    }

    return fragment
  }

  private fun onGooglePayReady(isReady: Boolean) {
    setGooglePayReady(isReady)
  }

  private fun onGooglePayResult(googlePayResult: GooglePayResult, promise: MethodChannel.Result) {
    _googlePayLock.safeRelease()

    when (googlePayResult) {
      is GooglePayResult.Completed -> {
        promise.success(googlePayResult.paymentMethod.toMap())
      }
      is GooglePayResult.Canceled -> {
        promise.success(null)
      }
      is GooglePayResult.Failed -> {
        promise.success(googlePayResult.error.toMap())
      }
    }
  }

  private fun emitDigitalWalletReadyEvent(previousState: Boolean) = uiOperation {
    val newState = isGooglePayReady()

    if (_hasEmittedDigitalWalletReadyEvent && newState == previousState) {
      return@uiOperation
    }

    _hasEmittedDigitalWalletReadyEvent = true
    val args = mapOf(DataKeys.DigitalWalletReadyParameterKey to newState)

    if (this::channel.isInitialized) {
      channel.invokeMethod(DataKeys.DigitalWalletReadyEventHandlerKey, args)
    }
  }

  private fun googlePayLockingOperation(operation: suspend() -> Unit) {
    CoroutineScope(Dispatchers.Main).launch {
      _googlePayLock.withPermit {
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
    const val DefaultFullNameRequired = false
    const val DefaultFullBillingAddressRequired = false

    // Default Digital Wallet Payment Method Request Options
    const val DefaultCurrencyMultiplier = 100
    const val DefaultCurrencyCode = "USD"

    const val MajorVersionIndex = 0
    const val MinorVersionIndex = 1
    const val BuildVersionIndex = 2
    const val DefaultVersionString = "0.0.0"
  }
}
