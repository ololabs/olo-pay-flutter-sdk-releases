//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<olo_pay_sdk/OloPaySdkPlugin.h>)
#import <olo_pay_sdk/OloPaySdkPlugin.h>
#else
@import olo_pay_sdk;
#endif

#if __has_include(<pay_ios/PayPlugin.h>)
#import <pay_ios/PayPlugin.h>
#else
@import pay_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [OloPaySdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"OloPaySdkPlugin"]];
  [PayPlugin registerWithRegistrar:[registry registrarForPlugin:@"PayPlugin"]];
}

@end
