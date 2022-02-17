//
//  FlutterZoomSdkPlugin+ShareServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+ShareServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation FlutterZoomSdkPlugin (ShareServiceDelegate)

- (void)onSinkMeetingActiveShare:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingActiveShare==%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveShare:userID];
        
        if (userID != 0) {
            MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
            if ([ms isMeetingChatLegalNoticeAvailable]) {
                NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
                NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}

- (void)onSinkSharingStatus:(MobileRTCSharingStatus)status userID:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkSharingStatus==%@ userID==%@", @(status),@(userID));
}

- (void)onSinkShareSizeChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkShareSizeChange==%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkShareSizeChange:userID];
    }
}

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingShareReceiving==%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingShareReceiving:userID];
    }
}

- (void)onAppShareSplash
{
//    NSLog(@"MobileRTC onAppShareSplash");
//    if (self.mainVC) {
//        [self.mainVC onAppShareSplash];
//    }
}

- (void)onSinkShareSettingTypeChanged:(MobileRTCShareSettingType)shareSettingType {
    NSLog(@"MobileRTC onSinkShareSettingTypeChanged==%lu", shareSettingType);
}
@end
