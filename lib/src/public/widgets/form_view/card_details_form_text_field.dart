// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/form_creation_params.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/error_background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/field_divider_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/widgets/form_view/card_details_form_text_field_controller.dart';
import 'package:olo_pay_sdk/src/public/widgets/single_line/card_details_single_line_text_field.dart';

/// Widget responsible for displaying a credit card input form
///
/// **_Important:_** Access to card details are intentionally restricted for
/// PCI compliance
///
/// ### Limitations
/// When compared to the functionality of the [CardDetailsSingleLineTextField],
/// this widget some limitations. We are looking for ways to improve
/// the experience with the form, and hope to address these limitations in future
/// releases:
/// - It is not possible to customize error messages or turn them off
/// - Styling in iOS is limited (see documentation of each styling parameter for details)
///
/// ### Sizing Considerations:
///
/// This widget hosts a native Android and iOS view wrapped by a [ConstrainedBox]
/// with default `constraints` set with a height appropriate for each platform.
/// This can be customized using the [constraints] property.
///
/// ### Example Implementation
///
/// ```dart
/// CardDetailsFormTextFieldController? _cardInputController;
///
/// void onFormControllerCreated(CardDetailsFormTextFieldController controller) {
///   _cardInputController = controller;
/// }
///
/// Future<void> createPaymentMethod() async {
///   try {
///     var paymentMethod = await _cardInputController?.createPaymentMethod();
///     if (paymentMethod != null) {
///       // Use paymentMethod to submit an order to Olo's Ordering API:
///       // https://developer.olo.com/docs/load/olopay#section/Submitting-a-Basket-via-the-Ordering-API
///     }
///   } on PlatformException catch (e) {
///     // Handle errors
///   }
/// }
///
/// @override
/// Widget build(BuildContext context) {
///   return Center(
///     child: Column(
///       children: <Widget>[
///         CardDetailsFormTextField(
///           onControllerCreated: onSingleLineControllerCreated,
///         ),
///         ElevatedButton(
///           onPressed: createPaymentMethod,
///           child: const Text("Submit Card Details"),
///         ),
///       ],
///     ),
///   ),
/// }
/// ```
class CardDetailsFormTextField extends StatefulWidget {
  /// Creates a new instance of this widget
  ///
  /// [onControllerCreated] can be used to get an instance of the controller associated with this widget.
  ///
  /// The [constraints] property can be used to set the height of the native views.
  ///
  /// Use the [errorAlignment] property to set the alignment of the built-in error message. _**(Android Only)**_
  ///
  /// The margin between the card input and the error message can be set with [errorMarginTop]. _**(Android Only)**_
  ///
  /// Hint text can be changed with the [hints] property. _**(Android Only)**_
  ///
  /// To customize the text within the widget use [textStyles]. _**(Limited on iOS. See [TextStyles] for documentation)**_
  ///
  /// Give the widget a custom background using [backgroundStyles]. _**(Limited on iOS. See [BackgroundStyles] for documentation)**_
  ///
  /// The dividers between the fields can be customized with [fieldDividerStyles]. _**(Android Only)**_
  ///
  /// Use [paddingStyles] to customize the padding within the widget. _**(Android Only)**_
  ///
  /// The [errorBackgroundStyles] property can be used to set the background styles for the error message. _**(Android Only)**_
  ///
  /// Use [errorPaddingStyles] to customize the padding within the error message. _**(Android Only)**_
  ///
  /// The [focusedHints] property can be used to set custom hint text for the fields of this widget when they are focused. _**(Android Only)**_
  ///
  /// Use [enabled] to control whether the widget will respond to user interactions
  CardDetailsFormTextField({
    super.key,
    required this.onControllerCreated,
    this.backgroundStyles,
    constraints,
    this.errorBackgroundStyles,
    this.onErrorMessageChanged,
    this.onValidStateChanged,
    this.enabled = true,
    this.textStyles,
    this.errorAlignment = TextFieldAlignment.left,
    this.errorMarginTop = _defaultErrorMarginTop,
    this.errorPaddingStyles = PaddingStyles.defaults,
    this.focusedHints = Hints.formFocusedDefaults,
    this.fieldDividerStyles = FieldDividerStyles.formDefaults,
    this.hints = Hints.formDefaults,
    this.paddingStyles = PaddingStyles.noPadding,
  }) : constraints = constraints ?? defaultConstraints;

  /// @nodoc
  static BoxConstraints defaultConstraints = Platform.isAndroid
      ? const BoxConstraints(maxHeight: 320)
      : const BoxConstraints(maxHeight: 200);

  /// @nodoc
  static const double _defaultErrorMarginTop = 8.0;

  /// A callback function to be notified when the controller associated with this widget is ready
  final CardDetailsFormTextFieldControllerCreated onControllerCreated;

  /// A callback function to be notified when the valid state of this widget
  /// changes
  final CardDetailsFormValidStateChanged? onValidStateChanged;

  /// Property to set the native view's height and width.
  /// Default is `BoxConstraints(maxHeight: 280)` on Android and `BoxConstraints(maxHeight: 200)` on iOS.
  final BoxConstraints constraints;

  /// A callback function to be notified when the error message associated with this widget changes (Android only)
  final CardDetailsErrorMessageChanged? onErrorMessageChanged;

  /// Alignment of the built-in error message. Default is `left` _**(Android Only)**_
  final TextFieldAlignment errorAlignment;

  /// Set the vertical margin between the input widget and the error message. _**(Android Only)**_
  /// Default is `8.0`
  final double errorMarginTop;

  /// Provide custom hint text for fields of this widget _**(Android Only)**_
  final Hints hints;

  /// Provide custom text styles for this widget
  ///
  /// **Note:** Many of these properties are only available on Android. See [TextStyles] for more documentation on what is available on each platform.
  ///
  /// Any properties that are `null` will be populated with values from the current theme,
  /// as defined by [TextStyles.merge]
  final TextStyles? textStyles;

  /// Provide custom background styles for this widget
  ///
  /// **Important:**
  ///   - On Android, this property will only have an effect on Android API 27 and newer
  ///   - On iOS, only the [BackgroundStyles.backgroundColor] property is available
  final BackgroundStyles? backgroundStyles;

  /// Provide custom divider styles for this widget _**(Android Only)**_
  final FieldDividerStyles? fieldDividerStyles;

  /// Provide custom padding for this widget _**(Android Only)**_
  ///
  /// **Important:** When setting [PaddingStyles.topPadding] and [PaddingStyles.bottomPadding] it is important to note
  /// that a value of `0.0` may not necessarily mean the text touches the top and bottom border of the view. This is largely
  /// due to Flutter's requirements for providing a specific height for native views. See [CardDetailsSingleLineTextField]
  /// for more information on height/sizing guidelines.
  final PaddingStyles paddingStyles;

  /// Provide custom background styles for this widget _**Android Only)**_
  ///
  /// **Important:** On Android, this property will only have an effect on Android API 27 and newer
  final ErrorBackgroundStyles? errorBackgroundStyles;

  /// Provide custom padding for the error message of this widget _**(Android Only)**_
  ///
  /// **Important:** When setting [PaddingStyles.topPadding] and [PaddingStyles.bottomPadding] it is important to note
  /// that a value of `0.0` may not necessarily mean the text touches the top and bottom border of the view. This is largely
  /// due to Flutter's requirements for providing a specific height for native views. See [CardDetailsSingleLineTextField]
  /// for more information on height/sizing guidelines.
  final PaddingStyles errorPaddingStyles;

  /// Provide custom hint text for the fields of this widget when they are focused _**(Android Only)**_
  final Hints focusedHints;

  /// Whether or not this widget will respond to user interactions
  final bool enabled;

  /// @nodoc
  @override
  State<CardDetailsFormTextField> createState() =>
      _CardDetailsFormTextFieldState();
}

class _CardDetailsFormTextFieldState extends State<CardDetailsFormTextField> {
  late CardDetailsFormTextFieldController _controller;
  MethodChannel? _channel;
  bool prematureRefresh = false;
  String _editedFieldsErrorMessage = "";
  ThemeData? _themeData;

  Future<void> platformViewCreatedCallback(id) async {
    _channel = MethodChannel('${DataKeys.formBaseMethodChannelKey}$id');
    _channel!.setMethodCallHandler(onMethodCall);

    _controller = CardDetailsFormTextFieldController(
      _channel!,
      onControllerError,
    );
    widget.onControllerCreated.call(_controller);

    if (prematureRefresh) {
      prematureRefresh = false;

      BackgroundStyles? themeAwareBackground = widget.backgroundStyles;
      bool darkMode =
          (_themeData != null && _themeData?.brightness == Brightness.dark);

      themeAwareBackground ??=
          (_themeData != null && _themeData?.brightness == Brightness.dark)
              ? BackgroundStyles.darkFormDefaults
              : BackgroundStyles.lightFormDefaults;

      TextStyles? themeAwareText = widget.textStyles;
      themeAwareText ??=
          (_themeData != null && _themeData?.brightness == Brightness.dark)
              ? TextStyles.darkFormDefaults
              : TextStyles.lightFormDefaults;

      refreshUI(
        FormCreationParams(
          hints: widget.hints,
          textStyles: TextStyles.merge(
            otherStyles: themeAwareText,
            theme: _themeData,
          ),
          backgroundStyles: BackgroundStyles.merge(
            otherStyles: themeAwareBackground,
            theme: _themeData,
          ),
          fieldDividerStyles: FieldDividerStyles.merge(
            otherStyles: widget.fieldDividerStyles,
            theme: _themeData,
          ),
          paddingStyles: widget.paddingStyles,
          focusedHints: widget.focusedHints,
          errorBackgroundStyles: ErrorBackgroundStyles.merge(
            theme: _themeData,
            otherStyles: widget.errorBackgroundStyles,
          ),
          errorPaddingStyles: widget.errorPaddingStyles,
          verticalSpacing: widget.errorMarginTop,
          errorAlignment: widget.errorAlignment,
          enabled: widget.enabled,
          darkMode: darkMode,
        ),
      );
    }
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case DataKeys.onValidStateChangedEventHandlerKey:
        return validStateChangedHandler(call);
      default:
        return;
    }
  }

  void validStateChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final bool isValid = args[DataKeys.isValidKey];
    widget.onValidStateChanged?.call(isValid);
  }

  void onControllerError(String errorMessage) {
    errorMessageChangeHandler(errorMessage);
  }

  void errorMessageChangeHandler(String errorMessage) {
    if (_editedFieldsErrorMessage != errorMessage) {
      setState(() {
        _editedFieldsErrorMessage = errorMessage;
      });
      widget.onErrorMessageChanged?.call(_editedFieldsErrorMessage);
    }
  }

  Future<void> refreshUI(FormCreationParams params) async {
    try {
      if (_channel == null) {
        prematureRefresh = true;
        return;
      }

      return await _channel!.invokeOloMethod(DataKeys.refreshUiMethod, {
        DataKeys.creationParameters: params.toMap(),
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(error: e, trace: trace);
    }
  }

  @override
  void didUpdateWidget(covariant CardDetailsFormTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    var newThemeData = Theme.of(context);

    BackgroundStyles? oldThemeAwareBackground = oldWidget.backgroundStyles;

    oldThemeAwareBackground ??=
        (_themeData != null && _themeData?.brightness == Brightness.dark)
            ? BackgroundStyles.darkFormDefaults
            : BackgroundStyles.lightFormDefaults;

    TextStyles? oldThemeAwareText = widget.textStyles;
    oldThemeAwareText ??=
        (_themeData != null && _themeData?.brightness == Brightness.dark)
            ? TextStyles.darkFormDefaults
            : TextStyles.lightFormDefaults;

    bool darkMode =
        (_themeData != null && _themeData?.brightness == Brightness.dark);

    final oldParams = FormCreationParams(
      textStyles: TextStyles.merge(
        otherStyles: oldThemeAwareText,
        theme: _themeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: oldThemeAwareBackground,
        theme: _themeData,
      ),
      fieldDividerStyles: FieldDividerStyles.merge(
        otherStyles: oldWidget.fieldDividerStyles,
        theme: _themeData,
      ),
      hints: oldWidget.hints,
      paddingStyles: oldWidget.paddingStyles,
      focusedHints: oldWidget.focusedHints,
      errorBackgroundStyles: ErrorBackgroundStyles.merge(
        theme: _themeData,
        otherStyles: oldWidget.errorBackgroundStyles,
      ),
      errorPaddingStyles: oldWidget.errorPaddingStyles,
      verticalSpacing: oldWidget.errorMarginTop,
      errorAlignment: oldWidget.errorAlignment,
      enabled: oldWidget.enabled,
      darkMode: darkMode,
    );

    BackgroundStyles? themeAwareBackground = widget.backgroundStyles;
    themeAwareBackground ??= (newThemeData.brightness == Brightness.dark)
        ? BackgroundStyles.darkFormDefaults
        : BackgroundStyles.lightFormDefaults;

    TextStyles? themeAwareText = widget.textStyles;
    themeAwareText ??= (newThemeData.brightness == Brightness.dark)
        ? TextStyles.darkFormDefaults
        : TextStyles.lightFormDefaults;

    bool newDarkMode = (newThemeData.brightness == Brightness.dark);

    final newParams = FormCreationParams(
      textStyles: TextStyles.merge(
        otherStyles: themeAwareText,
        theme: newThemeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: themeAwareBackground,
        theme: newThemeData,
      ),
      fieldDividerStyles: FieldDividerStyles.merge(
        otherStyles: widget.fieldDividerStyles,
        theme: newThemeData,
      ),
      hints: widget.hints,
      paddingStyles: widget.paddingStyles,
      focusedHints: widget.focusedHints,
      errorBackgroundStyles: ErrorBackgroundStyles.merge(
        theme: newThemeData,
        otherStyles: widget.errorBackgroundStyles,
      ),
      errorPaddingStyles: widget.errorPaddingStyles,
      verticalSpacing: widget.errorMarginTop,
      errorAlignment: widget.errorAlignment,
      enabled: widget.enabled,
      darkMode: newDarkMode,
    );

    if (!newParams.isEqualTo(oldParams)) {
      _themeData = newThemeData;
      refreshUI(newParams);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    const String viewType = DataKeys.formViewTypeKey;

    BackgroundStyles? themeAwareBackground = widget.backgroundStyles;
    themeAwareBackground ??=
        (_themeData != null && _themeData?.brightness == Brightness.dark)
            ? BackgroundStyles.darkFormDefaults
            : BackgroundStyles.lightFormDefaults;

    TextStyles? themeAwareText = widget.textStyles;
    themeAwareText ??=
        (_themeData != null && _themeData?.brightness == Brightness.dark)
            ? TextStyles.darkFormDefaults
            : TextStyles.lightFormDefaults;

    bool darkMode =
        (_themeData != null && _themeData?.brightness == Brightness.dark);

    final params = FormCreationParams(
      hints: widget.hints,
      textStyles: TextStyles.merge(
        otherStyles: themeAwareText,
        theme: _themeData,
      ),
      backgroundStyles: BackgroundStyles.merge(
        otherStyles: themeAwareBackground,
        theme: _themeData,
      ),
      fieldDividerStyles: FieldDividerStyles.merge(
        otherStyles: widget.fieldDividerStyles,
        theme: _themeData,
      ),
      paddingStyles: widget.paddingStyles,
      focusedHints: widget.focusedHints,
      errorBackgroundStyles: ErrorBackgroundStyles.merge(
        theme: _themeData,
        otherStyles: widget.errorBackgroundStyles,
      ),
      errorPaddingStyles: widget.errorPaddingStyles,
      verticalSpacing: widget.errorMarginTop,
      errorAlignment: widget.errorAlignment,
      enabled: widget.enabled,
      darkMode: darkMode,
    ).toMap();

    return ConstrainedBox(
      constraints: widget.constraints,
      child: Builder(
        builder: (context) {
          if (Platform.isAndroid) {
            return AndroidView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          } else {
            return UiKitView(
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParamsCodec: const StandardMessageCodec(),
              creationParams: params,
              onPlatformViewCreated: platformViewCreatedCallback,
            );
          }
        },
      ),
    );
  }
}
