# Olo Pay Flutter SDK

## Table of Contents

- [Olo Pay Flutter SDK](#olo-pay-flutter-sdk)
  - [Table of Contents](#table-of-contents)
  - [About Olo Pay](#about-olo-pay)
  - [About the Flutter SDK](#about-the-flutter-sdk)
  - [Setup](#setup)
    - [Android-Specific Setup Steps](#android-specific-setup-steps)
      - [Supported Versions](#supported-versions)
      - [Activity Setup](#activity-setup)
        - [CardDetailsSingleLineTextView](#carddetailssinglelinetextview)
        - [Google Pay](#google-pay)
      - [Theme Setup](#theme-setup)
    - [iOS-Specific Setup Steps](#ios-specific-setup-steps)
      - [Supported Versions](#supported-versions-1)
      - [CocoaPods Setup](#cocoapods-setup)
  - [Getting Started](#getting-started)
    - [Payment Methods (new cards \& digital wallets)](#payment-methods-new-cards--digital-wallets)
    - [CVV Tokens (previously saved cards)](#cvv-tokens-previously-saved-cards)
  - [Handling Exceptions](#handling-exceptions)
    - [Example](#example)
  - [Native View Widgets](#native-view-widgets)
    - [Differences from Standard Flutter Widgets](#differences-from-standard-flutter-widgets)
      - [Sizing Differences](#sizing-differences)
    - [Available Widgets](#available-widgets)
      - [Credit Card Details Widgets](#credit-card-details-widgets)
      - [CVV Details Widget](#cvv-details-widget)
      - [Digital Wallet Button Widget](#digital-wallet-button-widget)

## About Olo Pay

[Olo Pay](https://www.olo.com/solutions/pay/) is an E-commerce payment solution designed to help restaurants grow, 
protect, and support their digital ordering and delivery business. Olo Pay is specifically designed for digital 
restaurant ordering to address the challenges and concerns that weʼve heard from thousands of merchants.

## About the Flutter SDK

The Olo Pay Flutter SDK allows partners to easily add PCI-compliant credit card input widgets and digital wallets 
(Apple Pay & Google Pay) to their checkout flow and seamlessly integrate with the Olo Ordering API.

Use of the plugin is subject to the terms of the [Olo Pay SDK License](LICENSE.md).

This SDK documentation provides information on how to use the Flutter SDK in a Flutter app. For more information about 
integrating Olo Pay into your payment solutions, including information about setup, testing, and certification, refer to our 
[Olo Pay Dev Portal Documentation](https://developer.olo.com/docs/load/olopay) _(Note: requires an Olo Developer account)_.

## Setup

### Android-Specific Setup Steps

#### Supported Versions

The minimum supported version is [Android API 23](https://developer.android.com/tools/releases/platforms#6.0). The Android app's minimum API version must be set to 23 or higher.

#### Activity Setup

By default, when generating a new app, Flutter creates an activity (usually named `MainActivity`) that inherits from [FlutterActivity](https://api.flutter.dev/javadoc/io/flutter/app/FlutterActivity.html). 

But certain aspects of the Olo Pay SDK (listed below) require the main activity of the app to inherit from [FlutterFragmentActivity](https://api.flutter.dev/javadoc/io/flutter/app/FlutterFragmentActivity.html).

To switch the base activity type, find the application's `MainActivity` class and change it to inherit from `FlutterFragmentActivity`
```kotlin
class MainActivity: FlutterFragmentActivity() {
}
```
##### CardDetailsSingleLineTextView

Attempting to use the [CardDetailsSingleLineTextView](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CardDetailsSingleLineTextField-class.html) widget when `FlutterFragmentActivity` is not used will cause a placeholder to be displayed with a message to switch to `FlutterFragmentActivity`. A message will also be logged to the debug console.

##### Google Pay

Attempting to [initialize Google Pay](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/OloPaySdk/initializeOloPay.html) when `FlutterFragmentActivity` is not used will result in an [invalidGooglePaySetup](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/ErrorCodes/invalidGooglePaySetup-constant.html) error code. A message will also be logged to the debug console.

#### Theme Setup
The Android app's themes needs to use one of the `Theme.AppCompat` or `Theme.MaterialComponents` themes (directly
or indirectly) in order to use [widgets](#native-view-widgets) provided by the SDK. 

To find the name of the theme in your theme, open the Android app's `AndroidManifest.xml` file and look for
the `android:theme` attribute. This could be specified in the app's `<application>` or `<activity>` tags (or both).

After finding the name of the theme, locate the file where it is defined. This is typically in `res/values/styles.xml`.
Note that if your app supports multiple configurations there may be multiple definitions of the theme in different 
files (such as `res/values-night/styles.xml`). 

**IMPORTANT:** _All definitions of the theme must be updated to use an approved 
theme._

**NOTE:** If you open the project in Android Studio and use the Android Project view, all versions of the styles.xml file will be grouped under a logical 
`res/values/styles` folder, making it easier to locate all versions of the `styles.xml` file. 

**Example:**
```xml
<!-- The parent attribute specifies an appropriate theme -->
<style name="LaunchTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
  <!-- Custom theme definitions -->
</style>
```

### iOS-Specific Setup Steps

#### Supported Versions

The minimum supported version is [iOS 13](https://support.apple.com/en-us/HT210393#13). The iOS app's
settings must be set to target iOS 13 or newer.

#### CocoaPods Setup

Add the following lines at the top of your app's Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/ololabs/podspecs.git'
```

Open a terminal, navigate to your app's iOS folder (usually `<projectName>/ios`), and run the following command:

```bash
pod install
```

## Getting Started

Here is a high-level overview on how to integrate the SDK into an app:

### Payment Methods (new cards & digital wallets)

This approach is used for cards that have not previously been saved on file with Olo. This includes new credit cards and digital wallets. With this approach both card input widgets and digital wallets return a [PaymentMethod](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/PaymentMethod-class.html) instance that is then used to submit a basket with Olo's Ordering API. Specific details can be found below.

1. Import the SDK
    ```dart
    import 'package:olo_pay_sdk/olo_pay_sdk.dart';
    ```
1. Initialize Olo Pay (see [OloPaySdk.initializeOloPay()](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/OloPaySdk/initializeOloPay.html))
1. Create the [PaymentMethod](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/PaymentMethod-class.html)
    - **Credit Card Widget**
        1. Add a credit card details [widget](#credit-card-details-widgets) to your app
        1. Use the widget's `onControllerCreated()` callback to get a controller instance
        1. Create a [PaymentMethod](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/PaymentMethod-class.html) by calling `createPaymentMethod()` on the controller
    - **Digital Wallets** _(Apple Pay & Google Pay)_
        1. Set [OloPaySdk.onDigitalWalletReady](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/OloPaySdk/onDigitalWalletReady.html) and wait for the callback to indicate digital wallets can be used
        2. Add a [DigitalWalletButton](#digital-wallet-button-widget) to your app
        3. Create a payment method via [OloPaySdk.createDigitalWalletPaymentMethod()](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/OloPaySdk/createDigitalWalletPaymentMethod.html)
2. Submit the order to [Olo's Ordering API](https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API) using the [PaymentMethod](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/PaymentMethod-class.html) details.

### CVV Tokens (previously saved cards)

This approach is used for cards that have previously been saved on file with Olo, and you want to reverify the CVV of the saved card prior to submitting a basket and processing a payment. The [CvvTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvTextField-class.html) widget will provide a [CvvUpdateToken](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvUpdateToken-class.html) instance that is then used to submit a basket with Olo's Ordering API. Specific details can be found below.

1. Import the SDK
    ```dart
    import 'package:olo_pay_sdk/olo_pay_sdk.dart';
    ```
1. Initialize Olo Pay (see [OloPaySdk.initializeOloPay()](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/OloPaySdk/initializeOloPay.html))
1. Create the [CvvUpdateToken](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvUpdateToken-class.html)
    1. Add the [CvvTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvTextField-class.html) widget to your app
    1. Use the widget's `onControllerCreated()` callback to get a controller instance
    1. Create a [CvvUpdateToken](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvUpdateToken-class.html) by calling `createCvvUpdateToken()` on the controller
1. Submit the order to [Olo's Ordering API](https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API) using the [CvvUpdateToken](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvUpdateToken-class.html) details.

## Handling Exceptions

When calling functions in the SDK, there is a chance that the call will fail. When this happens the returned error object will be a [PlatformException](https://api.flutter.dev/flutter/services/PlatformException-class.html) and will contain `code` and `message` properties indicating why the method call failed.

The `code` property will always map to a value from [ErrorCodes](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/ErrorCodes-class.html).

Refer to the documentation for each method for information on possible error codes that will be returned if there is an error. 

### Example

```dart
try {
  const paymentMethodData = await oloPaySdk.createDigitalWalletPaymentMethod();
  //Handle payment method data
} on PlatformException catch (e) {
  if (e.code == ErrorCodes.generalError) {
    // Handle exception
  }
}
```

## Native View Widgets

Widgets in the Olo Pay SDK are used to display credit card input fields in an app, and card details are not accessible by the developer to help reduce the effort needed to maintain PCI compliance.

### Differences from Standard Flutter Widgets

Widgets in the Olo Pay SDK host native Android and iOS views, which behave differently than standard Flutter widgets. Details of these differences can be found below.

#### Sizing Differences

One of the biggest differences is that native widgets need to have a specific height defined. Internally, widgets in the Olo Pay SDK are wrapped with a [ConstrainedBox](https://api.flutter.dev/flutter/widgets/ConstrainedBox-class.html) with a default height that works in most scenarios. It is possible to pass in constraints if the default values need to be changed.

Widgets in the Olo Pay SDK will resize their views to fit the bounds specified. Please refer to documentation for each widget for information regarding recommended heights and approaches to sizing.

**Note:** Prior to `v1.2.0` [CardDetailsSingleLineTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CardDetailsSingleLineTextField-class.html) behaved differently on Android and iOS. Refer to [CardDetailsSingleLineTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CardDetailsSingleLineTextField-class.html) documentation for details.

### Available Widgets


#### Credit Card Details Widgets

- **[CardDetailsSingleLineTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CardDetailsSingleLineTextField-class.html)** - This widget displays all credit card details in a single input field and is the most compressed way to display a credit card input view.

- **[CardDetailsFormTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CardDetailsFormTextField-class.html)** - This widget displays credit card fields in a multi-view form

#### CVV Details Widget

- **[CvvTextField](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/CvvTextField-class.html)** - This widget displays a single input field that can be used to tokenize a card's CVV code for revalidation of saved cards.

#### Digital Wallet Button Widget

- **[DigitalWalletButton](https://pub.dev/documentation/olo_pay_sdk/latest/olo_pay_sdk/DigitalWalletButton-class.html)** - This widget displays a native Apple Pay or Google Pay button (depending on the device) that can be used to start the digital wallet payment sheet.