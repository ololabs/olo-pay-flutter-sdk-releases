// Copyright © 2022 Olo Inc. All rights reserved.
// This software is made available under the Olo Pay SDK License (See LICENSE.md file)
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:checked_yaml/checked_yaml.dart';

class OloPubspec {
  final String buildType;
  final String version;

  OloPubspec({required this.buildType, required this.version});

  factory OloPubspec.parse(
    String yaml, {
    Uri? sourceUrl,
    bool lenient = false,
  }) =>
      checkedYamlDecode(
        yaml,
        (map) => OloPubspec(
          buildType: map!["buildType"],
          version: Pubspec.fromJson(map).version!.canonicalizedVersion,
        ),
        sourceUrl: sourceUrl,
      );
}
