//
//  FlutterZoomSdkPlugin+WebinarServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+WebinarServiceDelegate.h"

@implementation FlutterZoomSdkPlugin (WebinarServiceDelegate)

- (void)onSinkAllowAttendeeChatNotification:(MobileRTCChatAllowAttendeeChat)currentPrivilege
{
    NSLog(@"onSinkAllowAttendeeChatNotification %zd",currentPrivilege);
}

- (void)onSinkQAAllowAskQuestionAnonymouslyNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAskQuestionAnonymouslyNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeViewAllQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeViewAllQuestionNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeUpVoteQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeUpVoteQuestionNotification %@",@(beAllowed));
}

- (void)onSinkQAAllowAttendeeAnswerQuestionNotification:(BOOL)beAllowed
{
    NSLog(@"onSinkQAAllowAttendeeAnswerQuestionNotification %@",@(beAllowed));
}

- (void)onSinkPromptAttendee2PanelistResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode
{
    NSLog(@"onSinkPromptAttendee2PanelistResult %@",@(errorCode));
}

- (void)onSinkDePromptPanelist2AttendeeResult:(MobileRTCWebinarPromoteorDepromoteError)errorCode
{
    NSLog(@"onSinkDePromptPanelist2AttendeeResult %@",@(errorCode));
}

- (void)onSinkSelfAllowTalkNotification
{
    NSLog(@"onSinkSelfAllowTalkNotification");
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"The host would like you to speak"
                                                          message:[NSString stringWithFormat:@"If you choose to unmute, others in the webinar will be able to hear you. If the host or panelists decide to record, livestream, or archive the webinar after you unmute, your voice will be include."]
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Stay mute"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil
                               ]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Unmute"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
        [ms muteMyAudio:NO];
        [self.customMeetingVC.bottomPanelView updateMyAudioStatus];
    }
                               ]];
    
    [ topViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)onSinkSelfDisallowTalkNotification
{
    NSLog(@"onSinkSelfDisallowTalkNotification");
    [self.customMeetingVC.bottomPanelView updateMyAudioStatus];
}

#if 1
#pragma mark - Webinar Q&A
- (void)onSinkQAConnectStarted
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"Webinar Q&A--onSinkQAConnectStarted QA Enable:%d...", [ms isQAEnabled]);
}

- (void)onSinkQAConnected:(BOOL)connected
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"Webinar Q&A--onSinkQAConnected %d, QA Enable:%d...", connected, [ms isQAEnabled]);
}

- (void)onSinkQAOpenQuestionChanged:(NSInteger)count
{
    NSLog(@"Webinar Q&A--onSinkQAOpenQuestionChanged %zd...", count);
}

#endif

- (void)onSinkAttendeePromoteConfirmResult:(BOOL)agree userId:(NSUInteger)userId
{
    NSLog(@"MobileRTC onSinkAttendeePromoteConfirmResult %d userId=%@", agree, @(userId));
}

@end
