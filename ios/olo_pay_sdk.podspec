#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint olo_pay_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'olo_pay_sdk'
  s.version          = '2.0.4'
  s.summary          = 'Flutter Olo Pay SDK'
  s.description      = <<-DESC
Flutter Olo Pay SDK
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Olo, Inc' => 'developersupport@olo.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency "OloPaySDK", "5.2.1"
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
