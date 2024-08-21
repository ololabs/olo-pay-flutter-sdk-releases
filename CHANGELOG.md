# Olo Pay Flutter SDK Changelog

## v1.2.0 (Aug 20, 2024)

### Updates
- `CardDetailsSingleLineTextField`: Added ability to set alignment of the built in error message with `errorAlignment`
- `CardDetailsSingleLineTextField`: Changed default `maxHeight` to `45`
- `CardDetailsSingleLineTextField`: Changed default `errorMarginTop` to `8.0`
- Deprecated `ErrorCodes.missingParameter`: All previous usages have changed to `ErrorCodes.InvalidParameter`
- Introduce `CvvTextField` widget for CVV tokenization.

### Dependency Updates
- Native SDKs
    - Updated to use [Olo Pay Android SDK v3.1.1](https://github.com/ololabs/olo-pay-android-sdk-releases/releases/tag/3.1.1)
    - Updated to use [Olo Pay iOS SDK v4.0.2](https://github.com/ololabs/olo-pay-ios-sdk-releases/releases/tag/4.0.2)

- Android Project
    - Updated to Gradle v8.2
    - Updated to Java v17
    - Updated to `com.android.tools.build:gradle:8.2.2`
    - Updated to `androidx.core:core-ktx:1.13.1`
    - Updated to `org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.1`
    - Updated to `com.google.android.material:material:1.12.0`

### Bug Fixes
- `CardDetailsSingleLineTextField`: Fix bug causing slight difference between the default input text error state color and the default error message color.
- `CardDetailsSingleLineTextField`: Fixed constraints so that the text input widget height properly expands/shrinks to match the height specified by the constructor parameters

## v1.1.0 (Mar 26, 2024) - First Public Release

### Breaking Changes
- `OloPaySetupParameters`: Removed `freshSetup` parameter

### Updates
- `CardDetailsSingleLineTextField`: Added built-in error message label to automatically display error messages
- `CardDetailsSingleLineTextField`: Added `errorStyles` property to style the built-in error message label
- `CardDetailsSingleLineTextField`: Added `displayErrorMessages` property to control visibility of the error message label
- `CardDetailsSingleLineTextField`: Added custom error message support via the `customErrorMessages` property
- `CardDetailsSingleLineTextField`: Added support for custom fonts via `TextStyles`
- `CardDetailsSingleLineTextField`: Fixed issue on iOS sometimes causing duplicate error messages to display
- `OloPaySdk`: Added `getFontNames()` for help with debugging custom font issues on iOS
- `OloPaySdk`: Changed `isDigitalWalletReady()` on iOS so it returns false if the SDK isn't initialized to align with Android behavior
- `TextStyles`: Added `fontAsset` and `iOSFontName` properties

## v1.0.1 (Feb 7, 2024)

### Bug Fixes
- `CardDetailsSingleLineTextField`: Fix small edge case preventing `textStyles` and `paddingStyles` from respecting theme values
- `CardType`: Fix typo causing Mastercard cards to map to `CardType.unknown`

### Updates
- `TextStyles`: Fixed incorrect documentation for `merge()`
- `TextStyles`: Added `defaultCursorColor` property

## v1.0.0 (Jan 26, 2024)

### Updates
- ReadMe updates

## v0.3.0 (Jan 17, 2024)

### Breaking Changes
- Consolidate import statements so only one is required
- Renamed classes and types for clarity
    - `PaymentCardDetailsSingleLineWidget` --> `CardDetailsSingleLineTextField`
    - `PaymentCardDetailsSingleLineWidgetController` --> `CardDetailsSingleLineTextFieldController`
    - `PaymentCardDetailsSingleLineWidgetControllerCreated` --> `CardDetailsSingleLineTextFieldControllerCreated`
    - `PaymentCardDetailsSingleLineWidgetOnErrorMessageChanged` --> `CardDetailsErrorMessageChanged`
    - `PaymentCardDetailsSingleLineWidgetOnInputChanged` --> `CardDetailsInputChanged`
    - `PaymentCardDetailsSingleLineWidgetOnValidStateChanged` --> `CardDetailsValidStateChanged`
    - `PaymentCardDetailsSingleLineWidgetOnFocusChanged` --> `CardDetailsFocusChanged`
- `PaymentMethod.cardType`: Changed type from `String` to `CardType`
- Updated all data classes to use `final` properties and `const` constructors
    - `OloPaySetupParameters`
    - `GooglePaySetupParameters`
    - `ApplePaySetupParameters`
    - `DigitalWalletPaymentParameters`
    - `GooglePayVendorParameters`
    - `PaymentMethod`
    - `CardFieldState`
    - `Hints`
    - `TextStyles`
    - `BackgroundStyles`
    - `PaddingStyles`

### Updates
- Change minimum iOS version to iOS 13
- `CardDetailsSingleLineTextField`: Add support for light/dark themes
- `CardDetailsSingleLineTextField`: Add explicit default styles
- `CardDetailsSingleLineTextField`: Add support for updating styles based on state changes


## v0.2.0 (Dec 21, 2023)

### Breaking Changes
- `OloPaySdk.initializeOloPay()`: Changed from positional to named parameters
- `PaymentCardDetailsSingleLineWidgetControllerCreated`: Moved typedef to `data_types.dart`
- `PaymentCardDetailsSingleLineWidget`: Changed `onControllerCreated` to a required parameter

### Updates
- `PaymentCardDetailsSingleLineWidget`: Background and text styling support
- `PaymentCardDetailsSingleLineWidget`: Added event handlers for error message changes, valid state changes, and input changes
- `PaymentCardDetailsSingleLineWigetController`: Additional methods for controlling/interacting with the widget
- Digital Wallet Support (Apple Pay & Google Pay)


## v0.1.0 (Dec 11, 2023)

### Initial Release
- Use `PaymentCardDetailsSingleLineWidget` to display a single line card input widget 
- Use `PaymentCardDetailsSingleLineWidgetController.createPaymentMethod` to create a payment method based on user-entered card details
- Uses [Olo Pay Android SDK v3.0.0](https://github.com/ololabs/olo-pay-android-sdk-releases/releases/tag/v3.0.0-full)
- Uses [Olo Pay iOS SDK v4.0.0](https://github.com/ololabs/olo-pay-ios-sdk-releases/releases/tag/v4.0.0)