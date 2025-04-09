// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/extensions/color_extensions.dart';
import 'package:olo_pay_sdk/src/public/widgets/form_view/card_details_form_text_field.dart';

/// Defines background and border styles for the [CardDetailsFormTextField] widget
///
/// Widgets using this class will use default values from the app's theme, as defined in [ErrorBackgroundStyles.merge]
class ErrorBackgroundStyles implements BackgroundStyles {
  /// Default border width
  ///
  /// **Important:** Default values are only used in conjunction with [ErrorBackgroundStyles.merge]
  static const defaultBorderWidth = 0.0;

  /// Default border radius
  ///
  /// **Important:** Default values are only used in conjunction with [ErrorBackgroundStyles.merge]
  static const defaultBorderRadius = 0.0;

  /// Default border color
  ///
  /// **Important:** Default values are only used in conjunction with [ErrorBackgroundStyles.merge]
  static const defaultBorderColor = Color.fromRGBO(189, 188, 188, 1);

  /// Default background color for light theme
  ///
  /// **Important:** Default values are only used in conjunction with [ErrorBackgroundStyles.merge]
  static const defaultLightThemeBackgroundColor = Colors.white;

  /// Default background color for dark theme
  ///
  /// **Important:** Default values are only used in conjunction with [ErrorBackgroundStyles.merge]
  static const defaultDarkThemeBackgroundColor = Colors.black;

  /// The background color of the widget
  @override
  final Color? backgroundColor;

  /// The color of the widget's border
  ///
  /// **Important:** If a border is defined it will outline all four sides of the widget
  @override
  final Color? borderColor;

  /// The width of the widget's border
  ///
  /// To remove the border entirely provide a value of `0.0`
  ///
  /// **Important:** If a border is defined it will outline all four sides of the widget
  @override
  final double? borderWidth;

  /// The corner radius of the widget's border
  ///
  /// **Important:** If a border is defined it will outline all four sides of the widget
  @override
  final double? borderRadius;

  /// Define custom background styles by providing values for each property
  const ErrorBackgroundStyles({
    required this.backgroundColor,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  // Define custom background styles by providing values for only the properties you want to customize
  const ErrorBackgroundStyles.only({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });

  /// Define custom background styles by merging [otherStyles] and values from [theme]
  ///
  /// Assigns values to all properties on this class, filling in `null` properties from [otherStyles] with values
  /// from [theme], as follows:
  /// - [ErrorBackgroundStyles.backgroundColor]
  ///   1. Attempts to use `theme.inputDecorationTheme.fillColor` first
  ///   1. Attempts to use `theme.colorScheme.surface` second
  ///   1. If [theme] or either of the above theme values are `null` it falls back to `Colors.white`
  /// - [ErrorBackgroundStyles.borderColor]
  ///   1. Attempts to use `theme.inputDecorationTheme.outlineBorder.color` first
  ///   1. Attempts to use `theme.colorScheme.onSurface` second
  ///   1. If either [theme] or the above theme value are `null` it falls back to `Color.fromRGBO(189, 188, 188, 1)`
  /// - [ErrorBackgroundStyles.borderWidth]
  ///   1. Attempts to use `theme.inputDecorationTheme.outlineBorder.width` first
  ///   1. If either [theme] or the above theme value are `null` it falls back to `0.0`
  /// - [ErrorBackgroundStyles.borderRadius]
  ///   1. If not defined by [otherStyles], defaults to `0.0`
  factory ErrorBackgroundStyles.merge({
    ErrorBackgroundStyles? otherStyles,
    required ThemeData? theme,
  }) {
    var defaultBackgroundColor =
        (theme != null && theme.brightness == Brightness.dark)
            ? defaultDarkThemeBackgroundColor
            : defaultLightThemeBackgroundColor;

    return ErrorBackgroundStyles(
      backgroundColor:
          otherStyles?.backgroundColor ??
          theme?.inputDecorationTheme.fillColor ??
          theme?.colorScheme.surface ??
          defaultBackgroundColor,
      borderColor:
          otherStyles?.borderColor ??
          theme?.inputDecorationTheme.outlineBorder?.color ??
          theme?.colorScheme.onSurface ??
          defaultBorderColor,
      borderWidth:
          otherStyles?.borderWidth ??
          theme?.inputDecorationTheme.outlineBorder?.width ??
          defaultBorderWidth,
      borderRadius: otherStyles?.borderRadius ?? defaultBorderRadius,
    );
  }

  /// @nodoc
  @override
  Map<String, dynamic> toMap() {
    return {
      DataKeys.backgroundColorKey: backgroundColor?.toHex(),
      DataKeys.borderColorKey: borderColor?.toHex(),
      DataKeys.borderWidthKey: borderWidth,
      DataKeys.borderRadiusKey: borderRadius,
    };
  }
}
