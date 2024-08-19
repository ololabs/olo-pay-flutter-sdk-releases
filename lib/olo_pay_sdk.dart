// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
/// This is the main library for the Olo Pay SDK and contains all classes, enums, and data types used by the SDK.
/// The main entry point for working with the SDK is the [OloPaySdk] class.
///
/// To use this library in your code, import it as follows
/// ```dart
/// import 'package:olo_pay_sdk/olo_pay_sdk.dart';
/// ```
///
/// For convenience in working with the documentation, additional sub-libraries are provided that break out the classes
/// into the following categories:
/// - [olo_pay_sdk_data_classes] lists all data classes and enums in the SDK
/// - [olo_pay_sdk_data_types] lists all custom data types defined in the SDK
/// - [olo_pay_sdk_widgets] lists all widget and controller classes defined in the SDK
library;

import 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';

// EXPORT ALL FILES NEEDED BY THE SDK
export 'package:olo_pay_sdk/src/public/olo_pay_sdk.dart';
export 'package:olo_pay_sdk/olo_pay_sdk_data_classes.dart';
export 'package:olo_pay_sdk/olo_pay_sdk_widgets.dart';
export 'package:olo_pay_sdk/olo_pay_sdk_data_types.dart';
