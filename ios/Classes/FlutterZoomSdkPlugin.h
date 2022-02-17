#import <Flutter/Flutter.h>
#import <MobileRTC/MobileRTC.h>
#import "CustomMeetingViewController.h"

@interface FlutterZoomSdkPlugin : NSObject<FlutterPlugin, FlutterStreamHandler, MobileRTCAuthDelegate>
@property (strong, nonatomic) FlutterMethodChannel *channel;
@property (strong, nonatomic) FlutterEventSink eventSink;
@property (strong, nonatomic) CustomMeetingViewController *customMeetingVC;
@property (strong, nonatomic) UIViewController *waitingVC;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *email;



-(void) init:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(void) join:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(void) meetingStatus:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(void) getZoomUserId:(FlutterMethodCall *)call withResult:(FlutterResult) result;

-(NSString*) getStateMessage:(MobileRTCMeetingState )state;

+(void) openVote;
@end
