//
//  FlutterZoomSdkPlugin+AudioServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+AudioServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation FlutterZoomSdkPlugin (AudioServiceDelegate)

#pragma mark - Audio Service Delegate

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingAudioStatusChange=%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:userID];
    }
}

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID audioStatus:(MobileRTC_AudioStatus)audioStatus
{
    NSLog(@"MobileRTC onSinkMeetingAudioStatusChange=%@, audioStatus=%@",@(userID), @(audioStatus));
}

- (void)onSinkMeetingMyAudioTypeChange
{
    NSLog(@"MobileRTC onSinkMeetingMyAudioTypeChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingMyAudioTypeChange];
    }
}

- (void)onSinkMeetingAudioTypeChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingAudioTypeChange:%@",@(userID));
}

- (void)onMyAudioStateChange
{
    NSLog(@"MobileRTC onMyAudioStateChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingAudioStatusChange:0];
        
    }
}

- (void)onSinkMeetingAudioRequestUnmuteByHost
{
    NSLog(@"MobileRTC onSinkMeetingAudioRequestUnmuteByHost");
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

- (void)onAudioOutputChange
{
    NSLog(@"MobileRTC onAudioOutputChange");
}

@end
