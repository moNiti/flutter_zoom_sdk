#import "FlutterZoomSdkPlugin.h"
#import <MobileRTC/MobileRTC.h>

// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816


@implementation FlutterZoomSdkPlugin
FlutterMethodChannel* channel;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_zoom_sdk"
            binaryMessenger:[registrar messenger]];
  FlutterZoomSdkPlugin* instance = [[FlutterZoomSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
    
    
    FlutterEventChannel* eventChannel = [FlutterEventChannel
        eventChannelWithName:@"flutter_zoom_sdk_event_stream"
              binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      return [self init:call withResult:result];
  } else if ([@"join" isEqualToString:call.method]) {
      return [self join:call withResult:result];
  } else if ([@"meeting_status" isEqualToString:call.method]) {
      return [self meetingStatus:call withResult:result];
  } else if([@"get_zoom_user_id" isEqualToString:call.method]) {
      return [self getZoomUserId:call withResult:result];
  }else {
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
    result(@YES);
}

-(void) join:(FlutterMethodCall *)call withResult:(FlutterResult) result {
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    if (ms)
    {
        ms.delegate = self;
        ms.customizedUImeetingDelegate = self;
        //For Join a meeting with password
        MobileRTCMeetingJoinParam * joinParam = [[MobileRTCMeetingJoinParam alloc] init];
        joinParam.userName =  call.arguments[@"displayName"];
        joinParam.meetingNumber =  call.arguments[@"meetingNo"];
        joinParam.password =  call.arguments[@"password"];
        joinParam.webinarToken =  call.arguments[@"webinarToken"];;
//        ENABLE CUSTOMIZE MEETING BEFORE JOIN
        [[MobileRTC sharedRTC] getMeetingSettings].enableCustomMeeting = YES;
       
//        WEBINAR NEED REGISTER
        self.displayName = call.arguments[@"displayName"];
        self.email = call.arguments[@"email"];

        
        MobileRTCMeetError ret = [ms joinMeetingWithJoinParam:joinParam];
        NSLog(@"MobileRTC onJoinaMeeting ret: %@", ret == MobileRTCMeetError_Success ? @"Success" : @(ret));
        
    }
}


-(void) meetingStatus:(FlutterMethodCall *)call withResult:(FlutterResult) result {
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (ms)
    {
        MobileRTCMeetingState meetingState = [ms getMeetingState];
        result([self getStateMessage:meetingState]);
    } else {
        result( [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_UNKNOWN", @"", nil]);
       
    }
}

-(NSArray*) getStateMessage:(MobileRTCMeetingState )state {
 
    switch (state) {
        case  MobileRTCMeetingState_Idle:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_IDLE", @"No meeting is running", nil];
        case MobileRTCMeetingState_Connecting:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_CONNECTING", @"Connect to the meeting server", nil];
        case MobileRTCMeetingState_InMeeting:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_INMEETING", @"Meeting is ready and in process", nil];
        case MobileRTCMeetingState_WebinarPromote:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_WEBINAR_PROMOTE", @"Upgrade the attendees to panelist in webinar", nil];
        case MobileRTCMeetingState_WebinarDePromote:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_WEBINAR_DEPROMOTE", @"Demote the attendees from the panelist", nil];
        case MobileRTCMeetingState_Disconnecting:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_DISCONNECTING", @"Disconnect the meeting server, leave meeting status", nil];
        case MobileRTCMeetingState_Ended:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_ENDED", @"Meeting ends", nil];
        case MobileRTCMeetingState_Failed:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_FAILED", @"Failed to connect the meeting server", nil];
        case MobileRTCMeetingState_Reconnecting:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_RECONNECTING", @"Reconnecting meeting server status", nil];
        case MobileRTCMeetingState_WaitingForHost:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_WAITINGFORHOST", @"Waiting for the host to start the meeting", nil];
        case MobileRTCMeetingState_InWaitingRoom:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_IN_WAITING_ROOM", @"Participants who join the meeting before the start are in the waiting room", nil];
        default:
            return [[NSArray alloc]  initWithObjects:@"MEETING_STATUS_UNKNOWN", @"", nil];
                       
    }
}

-(void)getZoomUserId:(FlutterMethodCall *)call withResult:(FlutterResult)result {
    NSUInteger userId = [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)userId]
    result(inStr);
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

#pragma mark - FlutterEventSink
-(void)onMeetingStateChange:(MobileRTCMeetingState)state{
    if (state == MobileRTCMeetingState_InMeeting) {
           [self.customMeetingVC.videoVC.preVideoView removeFromSuperview];
    }
    if(state == MobileRTCMeetingState_InMeeting) {
        NSUInteger userId =  [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
        [[[MobileRTC sharedRTC] getMeetingService] changeName:self.displayName withUserID:userId];
    }
    _eventSink([self getStateMessage:state]);
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    NSLog(@"ON LISTEN WITH ARGUMENTS");
    _eventSink = events;
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if(ms ==nil){
        NSLog(@"MS == nill");
        FlutterError* error = [[FlutterError alloc] init ];
        return error;
    }
    NSLog(@"CALL ON LISTEN WITH ARGUMENT");
    ms.delegate = self;
    
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    NSLog(@"ON CANCEL WITH ARGUMENTS");
    _eventSink = nil;
    return nil;
}
- (void)onMeetingError:(MobileRTCMeetError)error message:(NSString *)message{
    NSLog(@"MEETING ERROR =>>>>>>> %@", message);
}

#pragma mark - Customize UI implement

- (void)onInitMeetingView {
    NSLog(@" =>>>>>>>>>>>>>>========= >>onInitMeetingView....");
    CustomMeetingViewController *vc = [[CustomMeetingViewController alloc] init];
    self.customMeetingVC = vc;
   
    UIViewController *rootVC  = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootVC addChildViewController:self.customMeetingVC];
    [rootVC.view addSubview:self.customMeetingVC.view];
    [self.customMeetingVC didMoveToParentViewController:rootVC];
    
    self.customMeetingVC.view.frame = rootVC.view.bounds;
    
}
- (void)onDestroyMeetingView {
    
    NSLog(@"onDestroyMeetingView....");
    
    [self.customMeetingVC willMoveToParentViewController:nil];
    [self.customMeetingVC.view removeFromSuperview];
    [self.customMeetingVC removeFromParentViewController];
    self.customMeetingVC = nil;
}

#pragma mark - WEBINAR NEED EMAIL implement

- (void)onSinkJoinWebinarNeedUserNameAndEmailWithCompletion:(BOOL (^_Nonnull)(NSString * _Nonnull username, NSString * _Nonnull email, BOOL cancel))completion
{
    if (completion)
    {
        BOOL ret = completion(self.displayName, self.email, NO);
        NSLog(@"%zd",ret);
    }
}

#pragma mark - WATING ROOM
- (void)onJBHWaitingWithCmd:(JBHCmd)cmd {
    NSLog(@"=>>>>>> CALL ON JBHWaitingWithCmd");
    UIViewController *rootVC  = [UIApplication sharedApplication].delegate.window.rootViewController;
    
//
//    self.customMeetingVC.view.frame = rootVC.view.bounds;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    switch (cmd) {
        case JBHCmd_Show:
        {
            // Get view controller.
            UIViewController *vc = [UIViewController new];
            
            // CREATE Waiting Label.
            UILabel *_titleLabel = [[UILabel alloc] initWithFrame: CGRectMake((rootVC.view.frame.size.width-120)/2, 30, 120, 40)];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            _titleLabel.text = @"กำลังเข้าสู่ห้องประชุม...";
            [_titleLabel sizeToFit];
      
//            ADD SUB VIEW
            [vc.view addSubview:_titleLabel];

            // Change modal present style.
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            UIViewController *rootVC  = [UIApplication sharedApplication].delegate.window.rootViewController;
            [rootVC presentViewController:vc animated:YES completion:nil];
            vc.view.frame = rootVC.view.bounds;
        }
            break;
            
        case JBHCmd_Hide:
        default:
        {
            UIViewController *rootVC  = [UIApplication sharedApplication].delegate.window.rootViewController;
            [rootVC dismissViewControllerAnimated:YES completion:NULL];
        }
            break;
    }
}


#pragma mark Meeting Delegate
//- (void)onMeetingStateChange:(MobileRTCMeetingState)state
//{
//    NSLog(@"==========>onMeetingStateChange");
//    if (state == MobileRTCMeetingState_InMeeting) {
//        [self.customMeetingVC.videoVC.preVideoView removeFromSuperview];
//    }
//}


- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingActiveVideo");
    self.customMeetingVC.pinUserId = userID;
    [self.customMeetingVC updateVideoOrShare];
}

- (void)onSinkMeetingPreviewStopped
{
    NSLog(@"==========>onSinkMeetingPreviewStopped");
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingAudioStatusChange");
    [self.customMeetingVC updateMyAudioStatus];

    [self.customMeetingVC updateVideoOrShare];
}

- (void)onSinkMeetingMyAudioTypeChange
{
    NSLog(@"==========>onSinkMeetingMyAudioTypeChange");
    [self.customMeetingVC updateMyAudioStatus];
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingVideoStatusChange");
    [self.customMeetingVC updateMyVideoStatus];

    [self.customMeetingVC updateVideoOrShare];
}

- (void)onMyVideoStateChange
{
    NSLog(@"==========>onMyVideoStateChange");
    [self.customMeetingVC updateMyVideoStatus];

    [self.customMeetingVC updateVideoOrShare];
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingUserJoin");
    [self.customMeetingVC updateVideoOrShare];
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingUserLeft");
    [self.customMeetingVC updateVideoOrShare];
}

- (void)onSinkMeetingActiveShare:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingActiveShare");
    BOOL sharing = (0 != userID);
    if (sharing)
    {
//        self.topPanelView.shrinkBtn.hidden = YES;
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        //Local Side Share
        if ([ms isSameUser:[ms myselfUserID] compareTo:userID])
        {
            [self.customMeetingVC showLocalShareView];
        }
        //Remote Side Share
        else
        {
            self.customMeetingVC.remoteShareVC.activeShareID = userID;
            [self.customMeetingVC showRemoteShareView];
        }
    }
    else
    {
//        self.topPanelView.shrinkBtn.hidden = NO;
        [self.customMeetingVC hideAnnotationView];
        [self.customMeetingVC showVideoView];
       
    }
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    NSLog(@"==========>onSinkShareSizeChange");
    if (!self.customMeetingVC.remoteShareVC.parentViewController)
        return;

    [self.customMeetingVC.remoteShareVC.shareView changeShareScaleWithUserID:userID];
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
    NSLog(@"==========>onSinkMeetingShareReceiving");
    if (!self.customMeetingVC.remoteShareVC.parentViewController)
        return;

    [self.customMeetingVC.remoteShareVC.shareView changeShareScaleWithUserID:userID];
}

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    NSLog(@"==========>onWaitingRoomStatusChange");
    if (needWaiting)
    {
        UIViewController *vc = [UIViewController new];
        
        vc.title = @"Need wait for host Approve";
        
        UIBarButtonItem *leaveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Leave", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onEndButtonClick:)];
        [vc.navigationItem setRightBarButtonItem:leaveItem];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.customMeetingVC presentViewController:nav animated:YES completion:NULL];
        
    }
    else
    {
        [self.customMeetingVC dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)onEndButtonClick:(id)sender
{
    NSLog(@"==========>onEndButtonClick");
    [self.customMeetingVC.actionPresenter leaveMeeting];
    [self.customMeetingVC dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - METHOD HANDLER

+(void) openVote {
    
    [channel invokeMethod:@"get_vote_url" arguments:nil result:^(id  _Nullable result) {
        if(result) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }
    }];
}
@end
