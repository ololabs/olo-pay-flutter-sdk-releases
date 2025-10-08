// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:olo_pay_sdk/src/private/data/data_keys.dart';

/// Represents an address
///
/// Currently only used for digital wallets, if billing address details are
/// requested to be returned in the generated digital wallet payment method.
class Address {
  /// The first line of the address
  final String address1;

  /// The second line of the address, if available. Otherwise an empty string.
  final String address2;

  /// The third line of the address, if available. Otherwise an empty string.
  final String address3;

  /// The city, town, neighborhood, or suburb
  final String locality;

  /// A country subdivision, such as a state or province
  final String administrativeArea;

  /// The postal or zip code
  final String postalCode;

  /// The two digit ISO country code
  final String countryCode;

  /// @nodoc
  const Address({
    required this.address1,
    required this.address2,
    required this.address3,
    required this.locality,
    required this.administrativeArea,
    required this.postalCode,
    required this.countryCode,
  });

  /// @nodoc
  factory Address.fromMap(Map<dynamic, dynamic> map) {
    return Address(
      address1: map[DataKeys.address1Key],
      address2: map[DataKeys.address2Key],
      address3: map[DataKeys.address3Key],
      locality: map[DataKeys.localityKey],
      administrativeArea: map[DataKeys.administrativeAreaKey],
      postalCode: map[DataKeys.pmPostalCodeKey],
      countryCode: map[DataKeys.pmCountryCodeKey],
    );
  }

  /// @nodoc
  @override
  String toString() {
    return '''
      address1: $address1
      address2: $address2
      address3: $address3
      locality: $locality
      administrativeArea: $administrativeArea
      postalCode: $postalCode
      countryCode: $countryCode
    ''';
  }
}
