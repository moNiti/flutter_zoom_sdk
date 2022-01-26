#import <Flutter/Flutter.h>
#import <MobileRTC/MobileRTC.h>

@interface FlutterZoomSdkPlugin : NSObject<FlutterPlugin, FlutterStreamHandler, MobileRTCMeetingServiceDelegate,MobileRTCAuthDelegate>

@property (strong, nonatomic) FlutterEventSink eventSink;

-(void) init:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(void) join:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(void) meetingStatus:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(NSString*) getStateMessage:(MobileRTCMeetingState )state;
@end
