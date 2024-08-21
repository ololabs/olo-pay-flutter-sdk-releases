// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)

/// Parameters for initializing Olo Pay
class OloPaySetupParameters {
  /// Whether or not the production environment should be used.
  ///
  /// Set to `true` for the production environment, `false` for the test environment.
  final bool productionEnvironment;

  /// Setup parameters used to initialize the Olo Pay SDK
  ///
  /// [productionEnvironment] determines whether the SDK is initialized to use the production or test environment. This
  /// defaults to `true`
  const OloPaySetupParameters({
    this.productionEnvironment = true,
  });
}
