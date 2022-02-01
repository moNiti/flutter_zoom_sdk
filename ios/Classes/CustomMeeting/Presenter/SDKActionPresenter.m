//
//  SDKActionPresenter.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/11/21.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "SDKActionPresenter.h"
#import <MobileRTC/MobileRTC.h>

@implementation SDKActionPresenter

- (BOOL)isMeetingHost
{
    return [[[MobileRTC sharedRTC] getMeetingService] isMeetingHost];
}

- (void)leaveMeeting
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) return;
    [ms leaveMeetingWithCmd:LeaveMeetingCmd_Leave];
}

- (void)EndMeeting
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) return;
    [ms leaveMeetingWithCmd:LeaveMeetingCmd_End];
}

- (void)presentParticipantsViewController
{
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [[[MobileRTC sharedRTC] getMeetingService] presentParticipantsViewController:topViewController];
}

- (BOOL)lockMeeting
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    return [ms lockMeeting:!ms.isMeetingLocked];
}

- (BOOL)lockShare
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    return [ms lockShare:!ms.isShareLocked];
}

@end
