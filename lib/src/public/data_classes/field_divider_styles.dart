// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/material.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/private/extensions/color_extensions.dart';
import 'package:olo_pay_sdk/src/public/widgets/form_view/card_details_form_text_field.dart';

/// Defines form inner divider styles for the [CardDetailsFormTextField] widget
///
/// Widgets using this class will use default values from the app's theme, as defined in [FieldDividerStyles.merge]
class FieldDividerStyles {
  /// Default divider width
  ///
  /// **Important:** Default values are only used in conjunction with [FieldDividerStyles.merge]
  static const defaultDividerWidth = 1.0;

  /// Default divider color
  ///
  /// **Important:** Default values are only used in conjunction with [FieldDividerStyles.merge]
  static const defaultBorderColor = Color.fromRGBO(189, 188, 188, 1);

  /// Convenience property for getting a [FieldDividerStyles] instance with defaults for the [CardDetailsFormTextField] widget
  static const FieldDividerStyles formDefaults = FieldDividerStyles(
    dividerColor: defaultBorderColor,
    dividerWidth: defaultDividerWidth,
  );

  /// The color of the widget's inner dividers
  ///
  /// **Important:** If a divider color is defined will apply to all inner dividers
  ///
  /// **Note:** Only available on the [CardDetailsFormTextField] widget on Android
  final Color? dividerColor;

  /// The width of the widget's inner dividers
  ///
  /// To remove the border entirely provide a value of `0.0`
  ///
  /// **Important:** If a divider width is defined it will apply to all inner dividers
  ///
  /// **Note:** Only available on the [CardDetailsFormTextField] widget on Android
  final double? dividerWidth;

  /// Define custom divider styles by providing values for each field
  const FieldDividerStyles({
    required this.dividerColor,
    required this.dividerWidth,
  });

  /// Define custom divider styles by providing values for only the fields you want to customize
  const FieldDividerStyles.only({this.dividerColor, this.dividerWidth});

  /// Define custom divider styles by merging [otherStyles] and values from [theme]
  ///
  /// Assigns values to all properties on this class, filling in `null` properties from [otherStyles] with values
  /// from [theme], as follows:
  /// - [FieldDividerStyles.dividerColor]
  ///   1. Attempts to use `theme.inputDecorationTheme.outlineBorder.color`first
  ///   1. Attempts to use `theme.colorScheme.onBackground` second
  ///   1. If [theme] or either of the above theme values are `null` it falls back to `Color.fromRGBO(189, 188, 188, 1)`
  /// - [FieldDividerStyles.dividerWidth]
  ///   1. Attempts to use `theme.inputDecorationTheme.outlineBorder.width` first
  ///   1. If either [theme] or the above theme value are `null` it falls back to `1.0`
  factory FieldDividerStyles.merge({
    FieldDividerStyles? otherStyles,
    required ThemeData? theme,
  }) {
    return FieldDividerStyles(
      dividerColor:
          otherStyles?.dividerColor ??
          theme?.inputDecorationTheme.outlineBorder?.color ??
          theme?.colorScheme.onSurface ??
          defaultBorderColor,
      dividerWidth:
          otherStyles?.dividerWidth ??
          theme?.inputDecorationTheme.outlineBorder?.width ??
          defaultDividerWidth,
    );
  }

  /// @nodoc
  Map<String, dynamic> toMap() {
    return {
      DataKeys.dividerColorKey: dividerColor?.toHex(),
      DataKeys.dividerWidthKey: dividerWidth,
    };
  }
}
