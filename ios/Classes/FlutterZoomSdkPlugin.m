#import "FlutterZoomSdkPlugin.h"
#import <MobileRTC/MobileRTC.h>

// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816


@implementation FlutterZoomSdkPlugin
// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   [SwiftFlutterZoomSdkPlugin registerWithRegistrar:registrar];
// }

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_zoom_sdk"
            binaryMessenger:[registrar messenger]];
  FlutterZoomSdkPlugin* instance = [[FlutterZoomSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      return [self init:call withResult:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void) init:(FlutterMethodCall *)call withResult:(FlutterResult) result {
    NSString* appKey = call.arguments[@"appKey"];
    NSString* appSecret = call.arguments[@"appSecret"];
    NSString* domain = call.arguments[@"domain"];
    
    MobileRTCSDKInitContext *context = [[MobileRTCSDKInitContext alloc] init];
        context.domain = domain;
        context.enableLog = YES;
    // Initialize the SDK
        BOOL sdkInitSuc = [[MobileRTC sharedRTC] initialize:context];

        if (sdkInitSuc) {
           // Get Auth Service
            MobileRTCAuthService *authService = [[MobileRTC sharedRTC] getAuthService];
        
            if (authService) {
           // Set up Auth Service
                authService.clientKey = appKey;
                authService.clientSecret = appSecret;
                authService.delegate = self;
            // Call Authentication function to authenticate the SDK
                [authService sdkAuth];
            }
        }
    result(@"ioshello me");
}
#pragma mark - MobileRTCAuthDelegate
/**
* To monitor the status and catch errors that might occur during the authorization process, implement the onMobileRTCAuthReturn method
*/
- (void)onMobileRTCAuthReturn:(MobileRTCAuthError)returnValue {
    switch (returnValue) {
        case MobileRTCAuthError_Success:
            NSLog(@"SDK successfully initialized.");
            break;
        case MobileRTCAuthError_KeyOrSecretEmpty:
            NSLog(@"SDK key/secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK key/secret.");
            break;
        case MobileRTCAuthError_KeyOrSecretWrong:
            NSLog(@"SDK key/secret is not valid.");
            break;
        case MobileRTCAuthError_Unknown:
            NSLog(@"SDK key/secret is not valid.");
            break;
        default:
            NSLog(@"SDK Authorization failed with MobileRTCAuthError: %u", returnValue);
    }
}

@end
