//
//  FlutterZoomSdkPlugin+MeetingServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+MeetingServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation FlutterZoomSdkPlugin (MeetingServiceDelegate)
#pragma mark - Meeting Service Delegate

- (void)onJoinMeetingConfirmed
{
    NSString *meetingNo = [[MobileRTCInviteHelper sharedInstance] ongoingMeetingNumber];
//    NSString *meetingPsw = [[[MobileRTC sharedRTC] getMeetingService] getMeetingPassword];
    NSLog(@"MobileRTC onJoinMeetingConfirmed MeetingNo: %@", meetingNo);
}

- (void)onJoinMeetingInfo:(MobileRTCJoinMeetingInfo)info
               completion:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion
{
//    if (self.mainVC) {
//        [self.mainVC onJoinMeetingInfo:info completion:(void (^)(NSString *displayName, NSString *password, BOOL cancel))completion];
//    }
}

#pragma mark -- For CustomUI Meeting
- (void)onWaitingRoomStatusChange:(BOOL)needWaiting
{
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onWaitingRoomStatusChange:needWaiting];
    }
}

- (void)onSinkWebinarNeedRegister:(NSString *)registerURL
{
    NSLog(@"MobileRTC onSinkWebinarNeedRegister %@",registerURL);
}

- (void)onSinkJoinWebinarNeedUserNameAndEmailWithCompletion:(BOOL (^_Nonnull)(NSString * _Nonnull username, NSString * _Nonnull email, BOOL cancel))completion
{
    if (completion)
    {
        NSString *username = self.displayName;
        NSString *email = self.email;
        BOOL ret = completion(username,email,NO);
        NSLog(@"MobileRTC onSinkJoinWebinarNeedUserNameAndEmailWithCompletion %@",@(ret));
    }
}

- (void)onSinkPanelistCapacityExceed
{
    NSLog(@"MobileRTC onSinkPanelistCapacityExceed");
}

- (void)onMeetingError:(MobileRTCMeetError)error message:(NSString*)message
{
    NSLog(@"MobileRTC onMeetingError:%zd, message:%@", error, message);
    
    if (error != 0) {
        NSString *errorCode = [NSString stringWithFormat:@"Error Code:%@",@(error)];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorCode message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onMeetingStateChange:(MobileRTCMeetingState)state
{
    NSLog(@"MobileRTC onMeetingStateChange:%@", @(state));
//    if (self.mainVC) {
//        [self.mainVC onMeetingStateChange:state];
//    }
    
    if (self.customMeetingVC) {
        [self.customMeetingVC onMeetingStateChange:state];
    }

    
//    Custom
    if(state == MobileRTCMeetingState_InMeeting) {
        NSUInteger userId =  [[[MobileRTC sharedRTC] getMeetingService] myselfUserID];
        [[[MobileRTC sharedRTC] getMeetingService] changeName:self.displayName withUserID:userId];
        
        UIView *meetingView  = [[[MobileRTC sharedRTC] getMeetingService] meetingView];
        if(meetingView) {
            NSLog(@"=>>>>>>>>>>>>>>> YES WEHAVE MEETING VIEW");
            TopPanelView *top = [[TopPanelView alloc] init];
            
            [meetingView addSubview: top];
            [top updateFrame];
           
        }
    }
    self.eventSink([self getStateMessage:state]);
}

- (void)onMeetingReady
{
    NSLog(@"MobileRTC onMeetingReady");
//    if (self.mainVC) {
//        [self.mainVC onMeetingReady];
//    }
}

//- (BOOL)onClickedShareButton:(UIViewController*)parentVC addShareActionItem:(NSMutableArray *)array
//{
//    return [self.mainVC onClickedShareButton:parentVC addShareActionItem:array];
//}

- (void)onOngoingShareStopped
{
    NSLog(@"There does not exist ongoing share");
    //    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    //    if (ms)
    //    {
    //        [ms startAppShare];
    //    }
}

- (BOOL)onClickedAudioButton:(UIViewController*)parentVC {
    
    return NO; // will show the default SDK UI
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) {
        return NO;
    }
    
    MobileRTCAudioType audioType = [ms myAudioType];
    switch (audioType)
    {
        case MobileRTCAudioType_VoIP: //voip
        case MobileRTCAudioType_Telephony: //phone
        {
            if (![ms canUnmuteMyAudio])
            {
                break;
            }
            BOOL isMuted = [ms isMyAudioMuted];
            [ms muteMyAudio:!isMuted];
            break;
        }
        case MobileRTCAudioType_None:
        {
            //Supported VOIP
            if ([ms isSupportedVOIP])
            {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8"))
                {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"To hear others\n please join audio", @"")
                                                                                             message:nil
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Call via Internet", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        //Join VOIP
                        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
                        if (ms)
                        {
                            [ms connectMyAudio:YES];
                        }
                    }]];
                    
                    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }]];
//                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

                    [topViewController presentViewController:alertController animated:YES completion:nil];
                }
            }
            break;
        }
    }
    
    return YES;
}

- (void)onSinkMeetingShowMinimizeMeetingOrBackZoomUI:(MobileRTCMinimizeMeetingState)state
{
    NSLog(@"MobileRTC onSinkMeetingShowMinimizeMeetingOrBackZoomUI %@",@(state));
}

- (void)onSinkAttendeeChatPriviledgeChanged:(MobileRTCMeetingChatPriviledgeType)currentPrivilege
{
    NSLog(@"MobileRTC onSinkAttendeeChatPriviledgeChanged %@",@(currentPrivilege));
}

#if 0
- (void)onMeetingEndedReason:(MobileRTCMeetingEndReason)reason
{
    NSLog(@"MobileRTC onMeetingEndedReason %d", reason);
}
#endif

#if 0
- (void)onMicrophoneStatusError:(MobileRTCMicrophoneError)error
{
    NSLog(@"MobileRTC onMicrophoneStatusError %d", error);
}
#endif

#if 1
- (void)onJBHWaitingWithCmd:(JBHCmd)cmd
{
    NSLog(@"MobileRTC onJBHWaitingWithCmd->%@",@(cmd));
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
#endif

#if 0
- (BOOL)onClickedInviteButton:(UIViewController*)parentVC addInviteActionItem:(NSMutableArray *)array
{
    return [self.mainVC onClickedInviteButton:parentVC addInviteActionItem:array];
}
#endif

#if 0
- (BOOL)onClickedParticipantsButton:(UIViewController*)parentVC;
{
    return [self.mainVC onClickedParticipantsButton:parentVC];
}
#endif

#if 0
- (BOOL)onClickedEndButton:(UIViewController*)parentVC endButton:(UIButton *)endButton
{
    return [self.mainVC onClickedEndButton:parentVC endButton:endButton];
}
#endif

#if 0
- (void)onClickedDialOut:(UIViewController*)parentVC isCallMe:(BOOL)me
{
    if (self.mainVC) {
        [self.mainVC onClickedDialOut:parentVC isCallMe:me];
    }
}

- (void)onDialOutStatusChanged:(DialOutStatus)status
{
    NSLog(@"MobileRTC onDialOutStatusChanged: %zd", status);
}
#endif

#pragma mark - H.323/SIP call state changed
#if 0
- (void)onSendPairingCodeStateChanged:(MobileRTCH323ParingStatus)state MeetingNumber:(unsigned long long)meetingNumber
{
    NSLog(@"MobileRTC onSendPairingCodeStateChanged %zd", state);
}

- (void)onCallRoomDeviceStateChanged:(H323CallOutStatus)state
{
    NSLog(@"MobileRTC onCallRoomDeviceStateChanged %zd", state);
}
#endif

#pragma mark - ZAK expired
#if 0
- (void)onZoomIdentityExpired
{
    NSLog(@"MobileRTC onZoomIdentityExpired");
}

#pragma mark - Closed Caption
- (void)onClosedCaptionReceived:(NSString *)message
{
    NSLog(@"MobileRTC onClosedCaptionReceived : %@",message);
}
#endif

#if 0
- (void)onSubscribeUserFail:(MobileRTCSubscribeFailReason)errorCode size:(NSInteger)size userId:(NSUInteger)userId
{
    NSLog(@"MobileRTC onSubscribeUserFail: %@ size:%@ userId:%@",@(errorCode),@(size),@(userId));
}
#endif

- (void)onCheckCMRPrivilege:(MobileRTCCMRError)result {
    NSLog(@"MobileRTC onCheckCMRPrivilege==%@", @(result));
}

- (void)onRecordingStatus:(MobileRTCRecordingStatus)status {
    NSLog(@"MobileRTC onRecordingStatus==%@", @(status));
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetingSettings *settings = [[MobileRTC sharedRTC] getMeetingSettings];
    if ([ms isMeetingChatLegalNoticeAvailable]
        && MobileRTCRecording_Start == status
        && [settings enableCustomMeeting]) {
        NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
        NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)onLocalRecordingStatus:(MobileRTCRecordingStatus)status {
    NSLog(@"MobileRTC onLocalRecordingStatus==%@", @(status));
}

#if 0
- (void)onAskToEndOtherMeeting:(void (^_Nonnull)(BOOL cancel))completion {
    NSLog(@"MobileRTC onAskToEndOtherMeeting");
    completion(NO);
}
#endif

- (void)onLiveStreamStatusChange:(MobileRTCLiveStreamStatus)liveStreamStatus {
    NSLog(@"MobileRTC onLiveStreamStatusChange==%lu", liveStreamStatus);
}

- (void)onSpotlightVideoChange:(BOOL)on
{
    NSLog(@"MobileRTC onSpotlightVideoChange==%@", @(on));
}

- (void)onSinkMeetingActiveVideoForDeck:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingActiveVideoForDeck==%@", @(userID));
}
@end
