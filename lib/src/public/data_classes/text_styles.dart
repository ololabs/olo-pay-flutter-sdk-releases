// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/extensions/color_extensions.dart';
import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

/// Defines text styles for widgets in the SDK
///
/// Widgets using this class will use default values from the app's theme, as defined in [TextStyles.merge]
class TextStyles {
  /// Default font size
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultFontSize = 14.0;

  /// Default hint text color
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultHintTextColor = Color.fromRGBO(91, 89, 89, 1);

  /// Default cursor color
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultCursorColor = Colors.grey;

  /// Default error color for a light theme
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultLightThemeErrorTextColor = Color.fromRGBO(196, 45, 50, 1);

  /// Default error color for a dark theme
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultDarkThemeErrorTextColor =
      Color.fromRGBO(219, 129, 132, 1);

  /// Default text color for a light theme
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultLightThemeTextColor = Color.fromRGBO(20, 20, 20, 1);

  /// Default text color for a dark theme
  ///
  /// **Important:** Default values are only used in conjunction with [TextStyles.merge]
  static const defaultDarkThemeTextColor = Color.fromRGBO(251, 251, 251, 1);

  /// The color for user-entered text on an input field
  ///
  /// **Important:** Due to the conversion process from Flutter colors to native Android colors, this property
  /// will only have effect on devices running Android API 27+
  final Color? textColor;

  /// The color of user-entered text when it is in an error state
  ///
  /// For a consistent look and feel, this color should generally be the same color used by your Text widget that
  /// displays error messages
  ///
  /// **Important:** Due to the conversion process from Flutter colors to native Android colors, this property
  /// will only have effect on devices running Android API 27+
  final Color? errorTextColor;

  /// Color of the cursor
  ///
  /// **Important:** On Android, this property was introduced in API 29 so it will only have effect on Android
  /// devices running Android API 29+
  final Color? cursorColor;

  /// Color of the placeholder for each input field
  ///
  /// **Important:** Due to the conversion process from Flutter colors to native Android colors, this property
  /// will only have effect on Android devices running API 27+
  final Color? hintTextColor;

  /// Size of the text within the card input widget
  final double? textSize;

  /// The path to a font asset defined in pubspec.yaml. If not specified, default platform-specific system fonts
  /// will be used.
  ///
  /// For help with determining possible causes for fonts not loading on iOS, see [OloPaySdk.getFontNames]
  final String? fontAsset;

  /// The name used by iOS to identify the font associated with [fontAsset].
  ///
  /// Most of the time the font name can be determined programmatically at run-time and this is not needed. There
  /// may be times when this value is needed such as:
  /// - Multiple font names are associated with a font and the loaded font name is different from the desired one.
  /// - The font doesn't properly specify font names and there isn't a way to programmatically load the font from just
  ///   a font file.
  ///
  /// For help with determining appropriate font names that can be used, see [OloPaySdk.getFontNames]
  final String? iOSFontName;

  /// Define custom text styles by providing values for each property
  const TextStyles(
      {required this.textColor,
      required this.errorTextColor,
      required this.cursorColor,
      required this.hintTextColor,
      required this.textSize,
      this.fontAsset,
      this.iOSFontName});

  /// Define custom text styles by providing values for only the properties you want to customize
  const TextStyles.only(
      {this.textColor,
      this.errorTextColor,
      this.cursorColor,
      this.hintTextColor,
      this.textSize,
      this.fontAsset,
      this.iOSFontName});

  /// Define custom text styles by merging [otherStyles] and values from [theme]
  ///
  /// Assigns values to all properties on this class, filling in `null` properties from [otherStyles] with values
  /// from [theme], as follows:
  /// - [TextStyles.textColor]
  ///   1. Attempts to use `theme.textTheme.bodyMedium.color` first
  ///   1. Attempts to use `theme.colorScheme.onBackground` second
  ///   1. If the above values are `null` and [theme] has a brightness of [Brightness.dark], it falls back to [TextStyles.defaultDarkThemeTextColor]
  ///   1. If the above values are `null` and [theme] is `null` or [theme] has a brightness of [Brightness.light], it falls back to [TextStyles.defaultLightThemeTextColor]
  /// - [TextStyles.errorTextColor]
  ///   1. Attempts to use `theme.inputDecorationTheme.errorStyle.color` first
  ///   1. Attempts to use `theme.colorScheme.onBackground` second
  ///   1. If the above values are `null` and [theme] has a brightness of [Brightness.dark], it falls back to [TextStyles.defaultDarkThemeErrorTextColor]
  ///   1. If the above values are `null` and [theme] is `null` or [theme] has a brightness of [Brightness.light], it falls back to [TextStyles.defaultLightThemeErrorTextColor]
  /// - [TextStyles.cursorColor]
  ///   1. Attempts to use `theme.textSelectionTheme.cursorColor` first
  ///   1. Attempts to use `theme.colorScheme.primary` second
  ///   1. If [theme] or either of the above theme values are `null` it falls back to [Colors.grey]
  /// - [TextStyles.hintTextColor]
  ///   1. Attempts to use `theme.inputDecorationTheme.hintStyle.color` first
  ///   1. Attempts to use `theme.hintColor` second
  ///   1. If [theme] or either of the above theme values are `null` it falls back to [TextStyles.defaultHintTextColor]
  /// - [TextStyles.textSize]
  ///   1. Attempts to use `theme.textTheme.bodyMedium.fontSize` first
  ///   1. If either [theme] or the above theme value are `null` it falls back to a size of `14`
  ///
  /// **Important:** This should not generally need to be called directly, as it is called by the widgets that take
  /// [TextStyles] as a parameter
  factory TextStyles.merge({
    TextStyles? otherStyles,
    required ThemeData? theme,
  }) {
    var defaultTextColor =
        (theme != null && theme.brightness == Brightness.dark)
            ? defaultDarkThemeTextColor
            : defaultLightThemeTextColor;

    var defaultErrorTextColor =
        (theme != null && theme.brightness == Brightness.dark)
            ? defaultDarkThemeErrorTextColor
            : defaultLightThemeErrorTextColor;

    return TextStyles(
      textColor: otherStyles?.textColor ??
          theme?.textTheme.bodyMedium?.color ??
          theme?.colorScheme.onBackground ??
          defaultTextColor,
      errorTextColor: otherStyles?.errorTextColor ??
          theme?.inputDecorationTheme.errorStyle?.color ??
          theme?.colorScheme.error ??
          defaultErrorTextColor,
      cursorColor: otherStyles?.cursorColor ??
          theme?.textSelectionTheme.cursorColor ??
          theme?.colorScheme.primary ??
          defaultCursorColor,
      hintTextColor: otherStyles?.hintTextColor ??
          theme?.inputDecorationTheme.hintStyle?.color ??
          theme?.hintColor ??
          defaultHintTextColor,
      textSize: otherStyles?.textSize ??
          theme?.textTheme.bodyMedium?.fontSize ??
          defaultFontSize,
      fontAsset: otherStyles?.fontAsset,
      iOSFontName: otherStyles?.iOSFontName,
    );
  }

  static Color getThemeAwareDefaultErrorTextColor(ThemeData? theme) {
    var defaultErrorTextColor =
        (theme != null && theme.brightness == Brightness.dark)
            ? defaultDarkThemeErrorTextColor
            : defaultLightThemeErrorTextColor;

    return theme?.inputDecorationTheme.errorStyle?.color ??
        theme?.colorScheme.error ??
        defaultErrorTextColor;
  }

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.textColorKey: textColor?.toHex(),
      DataKeys.errorTextColorKey: errorTextColor?.toHex(),
      DataKeys.cursorColorKey: cursorColor?.toHex(),
      DataKeys.hintTextColorKey: hintTextColor?.toHex(),
      DataKeys.textSizeKey: textSize,
      DataKeys.fontAssetKey: fontAsset,
      DataKeys.fontNameKey: iOSFontName,
    };
  }
}
