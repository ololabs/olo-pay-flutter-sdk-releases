// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Defines padding that is applied to a widget
class PaddingStyles {
  /// Default horizontal padding
  static const defaultHorizontalPadding = 8.0;

  /// Default vertical padding
  static const defaultVerticalPadding = 0.0;

  /// Convenience property for getting a [PaddingStyles] instance with all default values
  static const PaddingStyles defaults = PaddingStyles.only();

  /// The padding at the start (left) of the card input widget
  ///
  /// Defaults to a value of `8.0`
  final double startPadding;

  /// The padding at the end (right) of the card input widget
  ///
  /// Defaults to a value of `8.0`
  final double endPadding;

  /// The padding at the top of the card input widget
  ///
  /// Defaults to a value of `0.0`
  final double topPadding;

  /// The padding at the bottom of the card input widget
  ///
  /// Defaults to a value of `0.0`
  final double bottomPadding;

  /// Define custom padding by providing values for each property
  const PaddingStyles({
    required this.startPadding,
    required this.endPadding,
    required this.topPadding,
    required this.bottomPadding,
  });

  /// Define custom padding by providing values for only the properties you want to customize
  ///
  /// Values that aren't specified will default to [PaddingStyles.defaultHorizontalPadding] and [PaddingStyles.defaultVerticalPadding]
  const PaddingStyles.only({
    this.startPadding = defaultHorizontalPadding,
    this.endPadding = defaultHorizontalPadding,
    this.topPadding = defaultVerticalPadding,
    this.bottomPadding = defaultVerticalPadding,
  });

  /// @nodoc
  Map<String, double?> toMap() {
    return {
      DataKeys.startPaddingKey: startPadding,
      DataKeys.endPaddingKey: endPadding,
      DataKeys.topPaddingKey: topPadding,
      DataKeys.bottomPaddingKey: bottomPadding,
    };
  }
}
