#import "FlutterZoomSdkPlugin.h"
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
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
