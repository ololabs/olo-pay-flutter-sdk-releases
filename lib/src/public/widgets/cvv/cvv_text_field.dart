// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olo_pay_sdk/src/private/data/creation_params.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/data/strings.dart';
import 'package:olo_pay_sdk/src/private/extensions/method_channel_extensions.dart';
import 'package:olo_pay_sdk/src/private/factories/platform_exception_factory.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/card_field_state.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_field_errors.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_error_messages.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';
import 'package:olo_pay_sdk/src/public/data_types.dart';
import 'package:olo_pay_sdk/src/public/widgets/cvv/cvv_text_field_controller.dart';

/// TODO: ADD DOCUMENTATION AND EXAMPLE AFTER CONTROLLER CODE IS IMPLEMENTED/MERGED
class CvvTextField extends StatefulWidget {
  /// [onControllerCreated] allows a way to provide a callback to get an instance of the controller
  /// associated with this widget.
  ///
  /// [onErrorMessageChanged] allows a way to get error messages to display to the user as they enter card details.
  //
  /// [onInputChanged] provides the state of the widget any time the input values change.
  ///
  /// [onValidStateChanged] provides the state of the widget any time the state toggles between invalid and valid.
  ///
  /// [onFocusChanged] provides the state of the widget any time focus changes on the widget./
  ///
  /// The [constraints] propety can be used to set the height and width of the native view.
  ///
  /// Set [customErrorMessages] to override error messages used by this widget. This can also be used to provide support for localization.
  ///
  /// Use [displayErrorMessages] to hide the built-in error label.
  ///
  /// Use the [errorAlignment] property to set the alignment of the built-in error message.
  ///
  /// The error message can be styled with the [errorStyles] property.
  ///
  /// The margin between the input and the error message can be set with [errorMarginTop].
  ///
  /// Hint text can be changed with the [hint] property.
  ///
  /// To customize the text within the widget use [textStyles].
  ///
  /// Give the widget a custom background using [backgroundStyles].
  ///
  /// Use [paddingStyles] to customize the padding within the widget (this only affects Android).
  ///
  /// Creates a new instance of this widget
  const CvvTextField({
    super.key,
    required this.onControllerCreated,
    this.onErrorMessageChanged,
    this.onInputChanged,
    this.onValidStateChanged,
    this.onFocusChanged,
    this.constraints = const BoxConstraints(maxHeight: 45),
    this.customErrorMessages,
    this.displayErrorMessages = true,
    this.errorAlignment = Alignment.center,
    this.errorStyles,
    this.errorMarginTop = _defaultErrorMarginTop,
    this.hint = Strings.defaultCvvHint,
    this.textStyles,
    this.textAlignment = TextFieldAlignment.left,
    this.backgroundStyles,
    this.paddingStyles = PaddingStyles.defaults,
  });

  /// @nodoc
  static const double _defaultErrorMarginTop = 8.0;

  /// A callback function to be notified when the controller associated with this widget is ready
  final CvvTextFieldControllerCreated onControllerCreated;

  /// A callback function to be notified when the error message associated with this widget changes
  final CvvErrorMessageChanged? onErrorMessageChanged;

  /// A callback function to be notified when user-entered input changes
  final CvvInputChanged? onInputChanged;

  /// A callback function to be notified when the valid state of this widget changes
  final CvvValidStateChanged? onValidStateChanged;

  /// A callback function to be notified when the focused state of this widget changes
  final CvvFocusChanged? onFocusChanged;

  /// Property to set the native view's height and width. Default is `BoxConstraints(maxHeight: 45)`
  final BoxConstraints constraints;

  /// Provide custom error messages
  final CustomFieldErrors? customErrorMessages;

  /// Determines if error messages are displayed. Default is `true`
  final bool displayErrorMessages;

  /// Customize the look and feel of the built-in error message
  final TextStyle? errorStyles;

  /// Alignment of the built-in error message. Default is `Alignment.center`
  final Alignment errorAlignment;

  /// Set the margin between the input widget and the error message. Default is `8.0`
  final double errorMarginTop;

  /// Provide a custom hint for the text field. Defaults to [Strings.defaultCvvHint]
  final String hint;

  /// An object to provide custom text styles for the input widget
  ///
  /// Any properties that are `null` will be populated with values from the current theme,
  /// as defined by [TextStyles.merge]
  final TextStyles? textStyles;

  /// Alignment of the text within the field. Default is `TextFieldAlignment.left`
  final TextFieldAlignment textAlignment;

  /// An object to provide custom background styles for the input widget.
  ///
  /// **Important:** On Android, this property will only have an effect on Android API 27 and newer
  final BackgroundStyles? backgroundStyles;

  /// An object to provide custom padding for the input widget _**(Android Only)**_
  ///
  /// **Important:** When setting [PaddingStyles.topPadding] and [PaddingStyles.bottomPadding] it is important to note
  /// that a value of `0.0` may not necessarily mean the text touches the top and bottom border of the view. This is largely
  /// due to Flutter's requirements for providing a specific height for native views. See [CvvTextField] for more
  /// information on height/sizing guidelines.
  final PaddingStyles paddingStyles;

  @override
  State<CvvTextField> createState() => _CvvTextFieldState();
}

class _CvvTextFieldState extends State<CvvTextField> {
  late CvvTextFieldController _controller;
  MethodChannel? _channel;
  bool prematureRefresh = false;
  ThemeData? _themeData;
  String _editedFieldsErrorMessage = "";

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

  void inputChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final CardFieldState? fieldState =
        CardFieldState.fromMap(args[DataKeys.fieldStatesParameterKey]);

    if (fieldState == null) {
      assert(false,
          "CvvFieldText.inputChangedHandler(): fieldState was null when it should not be");
      return;
    }

    widget.onInputChanged?.call(fieldState);
  }

  void validStateChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final CardFieldState? fieldState =
        CardFieldState.fromMap(args[DataKeys.fieldStatesParameterKey]);

    if (fieldState == null) {
      assert(false,
          "CvvFieldtext.validStateChangedHandler(): fieldState was null when it should not be");
      return;
    }

    widget.onValidStateChanged?.call(fieldState);
  }

  void focusChangedHandler(MethodCall call) {
    final args = call.arguments as Map<dynamic, dynamic>;
    final CardFieldState? fieldState =
        CardFieldState.fromMap(args[DataKeys.fieldStatesParameterKey]);

    if (fieldState == null) {
      assert(false,
          "CvvTextField.focusChangedHandler(): fieldState was null when it should not be");
      return;
    }

    widget.onFocusChanged?.call(fieldState);
  }

  Future<void> platformViewCreatedCallback(id) async {
    _channel = MethodChannel('${DataKeys.cvvBaseMethodChannelKey}$id');
    _channel!.setMethodCallHandler(onMethodCall);

    if (prematureRefresh) {
      prematureRefresh = false;
      refreshUI(CreationParams(
        hints: Hints.only(cvv: widget.hint),
        textStyles:
            TextStyles.merge(otherStyles: widget.textStyles, theme: _themeData),
        backgroundStyles: BackgroundStyles.merge(
            otherStyles: widget.backgroundStyles, theme: _themeData),
        paddingStyles: widget.paddingStyles,
        customErrorMessages:
            CustomErrorMessages.only(cvv: widget.customErrorMessages),
        textAlignment: widget.textAlignment,
      ));
    }
    _controller = CvvTextFieldController(_channel!, onControllerError);
    widget.onControllerCreated.call(_controller);
  }

  Future<dynamic> onMethodCall(MethodCall call) async {
    switch (call.method) {
      case DataKeys.onErrorMessageChangedEventHandlerKey:
        return errorMessageChangeHandler(call.arguments as String);
      case DataKeys.onInputChangedEventHandlerKey:
        return inputChangedHandler(call);
      case DataKeys.onValidStateChangedEventHandlerKey:
        return validStateChangedHandler(call);
      case DataKeys.onFocusChangedEventHandlerKey:
        return focusChangedHandler(call);
      default:
        assert(false, "No method name keys matched, no event callbacks called");
        return;
    }
  }

  Future<void> refreshUI(CreationParams params) async {
    try {
      if (_channel == null) {
        prematureRefresh = true;
        return;
      }

      return await _channel!.invokeOloMethod(DataKeys.refreshUiMethod, {
        DataKeys.creationParameters: params.toMap(),
      });
    } catch (e, trace) {
      throw PlatformExceptionFactory.createFromError(
        error: e,
        trace: trace,
      );
    }
  }

  @override
  void didUpdateWidget(covariant CvvTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    var newThemeData = Theme.of(context);

    final oldParams = CreationParams(
      textStyles: TextStyles.merge(
          otherStyles: oldWidget.textStyles, theme: _themeData),
      backgroundStyles: BackgroundStyles.merge(
          otherStyles: oldWidget.backgroundStyles, theme: _themeData),
      hints: Hints.only(cvv: oldWidget.hint),
      paddingStyles: oldWidget.paddingStyles,
      customErrorMessages:
          CustomErrorMessages.only(cvv: oldWidget.customErrorMessages),
      textAlignment: oldWidget.textAlignment,
    );

    final newParams = CreationParams(
      textStyles:
          TextStyles.merge(otherStyles: widget.textStyles, theme: newThemeData),
      backgroundStyles: BackgroundStyles.merge(
          otherStyles: widget.backgroundStyles, theme: newThemeData),
      hints: Hints.only(cvv: widget.hint),
      paddingStyles: widget.paddingStyles,
      customErrorMessages:
          CustomErrorMessages.only(cvv: widget.customErrorMessages),
      textAlignment: widget.textAlignment,
    );

    if (!newParams.isEqualTo(oldParams)) {
      _themeData = newThemeData;
      refreshUI(newParams);
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);
    const String viewType = DataKeys.cvvViewTypeKey;

    final params = CreationParams(
      textStyles:
          TextStyles.merge(otherStyles: widget.textStyles, theme: _themeData),
      backgroundStyles: BackgroundStyles.merge(
          otherStyles: widget.backgroundStyles, theme: _themeData),
      hints: Hints.only(cvv: widget.hint),
      paddingStyles: PaddingStyles.defaults,
      customErrorMessages:
          CustomErrorMessages.only(cvv: widget.customErrorMessages),
      textAlignment: widget.textAlignment,
    ).toMap();

    final defaultErrorStyles = TextStyle(
      color: TextStyles.getThemeAwareDefaultErrorTextColor(_themeData),
    );

    return Column(
      children: [
        ConstrainedBox(
          constraints: widget.constraints,
          child: Container(
            // Android has a thinner right border than left due to clipping for an unknown reason. Adding this margin
            // fixes the visual difference but also will cause misalignment by ~1px on the right side of this widget.
            // Example: Sibling widgets wrapped in Padding
            margin: Platform.isAndroid ? const EdgeInsets.only(right: 1) : null,
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
          ),
        ),
        if (widget.displayErrorMessages)
          Column(
            children: [
              SizedBox(height: widget.errorMarginTop),
              Align(
                alignment: widget.errorAlignment,
                child: Text(
                  _editedFieldsErrorMessage,
                  style: widget.errorStyles ?? defaultErrorStyles,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
