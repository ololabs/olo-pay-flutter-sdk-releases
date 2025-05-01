// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:collection/collection.dart';
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';
import 'package:olo_pay_sdk/src/public/data_classes/background_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/custom_error_messages.dart';
import 'package:olo_pay_sdk/src/public/data_classes/hints.dart';
import 'package:olo_pay_sdk/src/public/data_classes/padding_styles.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_field_alignment.dart';
import 'package:olo_pay_sdk/src/public/data_classes/text_styles.dart';

class CreationParams {
  final Hints hints;
  final TextStyles textStyles;
  final BackgroundStyles backgroundStyles;
  final PaddingStyles paddingStyles;
  final CustomErrorMessages? customErrorMessages;
  final TextFieldAlignment? textAlignment;
  final bool enabled;

  const CreationParams({
    required this.hints,
    required this.textStyles,
    required this.backgroundStyles,
    required this.paddingStyles,
    required this.enabled,
    this.customErrorMessages,
    this.textAlignment,
  });

  bool isEqualTo(CreationParams? other) {
    return const DeepCollectionEquality().equals(toMap(), other?.toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      DataKeys.hintsArgumentsKey: hints.toMap(),
      DataKeys.textStylesArgumentsKey: textStyles.toMap(),
      DataKeys.backgroundStylesArgumentsKey: backgroundStyles.toMap(),
      DataKeys.paddingStylesArgumentsKey: paddingStyles.toMap(),
      DataKeys.customErrorMessages: customErrorMessages?.toMap(),
      DataKeys.textAlignmentKey: textAlignment?.toString(),
      DataKeys.enabledParameterKey: enabled,
    };
  }
}
