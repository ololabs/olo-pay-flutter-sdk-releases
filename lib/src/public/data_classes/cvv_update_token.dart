// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
/// Represents a CVV update token containing all the information needed to submit a baske via Olo's Ordering API
class CvvUpdateToken {
  /// The CVV update token id.
  ///
  /// This should be set to the token field when submiting a basket
  final String id;

  /// Whether or not this CVV update token was created in the production environment
  final bool productionEnvironment;

  /// Creates an instance of a CVV update token.
  ///
  /// **_Important:_** Other than for testing purposes, there should generally be no reason to create an insance of this class.
  const CvvUpdateToken({
    required this.id,
    required this.productionEnvironment,
  });

  /// @nodoc
  @override
  String toString() {
    return '''
      id: $id
      productionEnvironment: $productionEnvironment
    ''';
  }
}
