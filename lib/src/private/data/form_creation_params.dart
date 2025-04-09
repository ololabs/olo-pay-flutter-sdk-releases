// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:collection/collection.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/field_divider_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';

class FormCreationParams {
  final Hints hints;
  final TextStyles textStyles;
  final BackgroundStyles backgroundStyles;
  final FieldDividerStyles fieldDividerStyles;
  final PaddingStyles paddingStyles;
  final Hints focusedHints;
  final BackgroundStyles errorBackgroundStyles;
  final PaddingStyles errorPaddingStyles;
  final double verticalSpacing;
  final TextFieldAlignment errorAlignment;
  final String? fontAsset;
  final String? errorFontAsset;
  final bool enabled;
  final bool darkMode;

  const FormCreationParams({
    required this.hints,
    required this.textStyles,
    required this.backgroundStyles,
    required this.fieldDividerStyles,
    required this.paddingStyles,
    required this.focusedHints,
    required this.errorBackgroundStyles,
    required this.errorPaddingStyles,
    required this.verticalSpacing,
    required this.errorAlignment,
    required this.enabled,
    required this.darkMode,
    this.fontAsset,
    this.errorFontAsset,
  }) : super();

  bool isEqualTo(FormCreationParams? other) {
    return const DeepCollectionEquality().equals(toMap(), other?.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      DataKeys.hintsArgumentsKey: hints.toMap(),
      DataKeys.textStylesArgumentsKey: textStyles.toMap(),
      DataKeys.backgroundStylesArgumentsKey: backgroundStyles.toMap(),
      DataKeys.fieldDividerStylesArgumentsKey: fieldDividerStyles.toMap(),
      DataKeys.paddingStylesArgumentsKey: paddingStyles.toMap(),
      DataKeys.focusedFieldHintsArgumentsKey: focusedHints.toMap(),
      DataKeys.errorBackgroundStylesArgumentsKey: errorBackgroundStyles.toMap(),
      DataKeys.errorPaddingStylesArgumentsKey: errorPaddingStyles.toMap(),
      DataKeys.verticalSpacingKey: verticalSpacing,
      DataKeys.errorTextAlignmentKey: errorAlignment.toString(),
      DataKeys.fontAssetKey: fontAsset,
      DataKeys.errorFontAssetKey: errorFontAsset,
      DataKeys.enabledParameterKey: enabled,
      DataKeys.darkModeParameterKey: darkMode,
    };
  }
}
