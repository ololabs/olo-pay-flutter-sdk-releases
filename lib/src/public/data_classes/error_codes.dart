// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:flutter/services.dart';

/// A list of all possible error codes that can be used in conjunction with [PlatformException]
///
/// Olo Pay methods can throw a [PlatformException]. If they do, they will contain
/// a `code` property indicating the cause for the exception. The possible error codes are
/// defined in this class.
class ErrorCodes {
  /// An operation was attempted without first initializing the Olo Pay SDK
  static const uninitializedSdk = "SdkUninitialized";

  /// @Deprecated('All previous usages of this parameter have been changed to use [invalidParameter])
  static const missingParameter = "MissingParameter";

  /// A parameter is invalid
  ///
  /// This can occur if passing a parameter with an incorrect value (e.g. a negative payment amount or an empty string)
  static const invalidParameter = "InvalidParameter";

  /// Something really unexpected happened
  ///
  /// This error is not common and would usually indicate a problem with the state of the Flutter plugin outside
  /// of our control
  static const unexpectedError = "UnexpectedError";

  /// A general-purpose error occured
  static const generalError = "generalError";

  /// A general-purpose API error
  ///
  /// This error is not common and usually indicates a server-side problem
  static const apiError = "ApiError";

  /// A request has invalid parameters
  ///
  /// This error is not common. It could indicate a server-side problem or
  /// a change is needed to the Olo Pay SDK.
  static const invalidRequest = "InvalidRequest";

  /// An error occurred connecting to servers
  ///
  /// This error is not common and usually indicates a server-side problem.
  static const connection = "ConnectionError";

  /// The operation was cancelled
  ///
  /// This error is not common and indicates a request was cancelled.
  static const cancellation = "CancellationError";

  /// There was a problem with authentication
  ///
  /// This error is not common and indicates a change may be needed
  /// to the Olo Pay SDK.
  static const authentication = "AuthenticationError";

  /// A rate-limiting error occurred
  ///
  /// This error is not common.
  static const rateLimit = "RateLimitError";

  /// The card details are invalid
  ///
  /// This error is not common. The most common card errors indicate what the problem is with the card, such as
  /// [invalidNumber], [invalidExpiration], [invalidCvv], or [invalidPostalCode].
  static const invalidCardDetails = "InvalidCardDetails";

  /// The card number is invalid
  static const invalidNumber = "InvalidNumber";

  /// The expiration date is invalid
  static const invalidExpiration = "InvalidExpiration";

  /// The cvv field is invalid
  static const invalidCvv = "InvalidCVV";

  /// The postal code field is invalid
  static const invalidPostalCode = "InvalidPostalCode";

  /// The card is expired
  static const expiredCard = "ExpiredCard";

  /// The card was declined.
  static const cardDeclined = "CardDeclined";

  /// An error occurred while processing the card details
  static const processingError = "ProcessingError";

  /// An unknown card error occurred
  static const unknownCard = "UnknownCardError";

  /// An Apple Pay operation was attempted on a device that doesn't support Apple Pay
  static const applePayUnsupported = "ApplePayUnsupported";

  /// The Application is not properly configured to use Google Pay
  static const invalidGooglePaySetup = "InvalidGooglePaySetup";

  /// A Google Pay operation was attempted when it wasn't ready yet
  static const googlePayNotReady = "GooglePayNotReady";

  /// A Google Pay operation was attempted prior to it being initialized
  static const googlePayUninitialized = "GooglePayUninitialized";

  /// An internal Google Pay error occurred
  static const googlePayInternalError = "InternalError";

  /// An error occurred because the Google Pay was not configured correctly
  static const googlePayDeveloperError = "DeveloperError";

  /// A network error occurred while communicating with Google Pay servers
  static const googlePayNetworkError = "NetworkError";

  /// The font asset could not be found. Ensure the asset is defined in pubspec.yaml
  static const assetNotFound = "AssetNotFoundError";

  /// The font could not be loaded. The file is either corrupted or unsupported
  static const fontLoadError = "FontLoadError";
}
