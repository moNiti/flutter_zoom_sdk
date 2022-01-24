#import <Flutter/Flutter.h>
#import <MobileRTC/MobileRTC.h>

@interface FlutterZoomSdkPlugin : NSObject<FlutterPlugin, MobileRTCAuthDelegate>

-(void) init:(FlutterMethodCall *)call withResult:(FlutterResult) result;

//-(void) join:(FlutterMethodCall *)call withResult:(FlutterResult) result;
@end
