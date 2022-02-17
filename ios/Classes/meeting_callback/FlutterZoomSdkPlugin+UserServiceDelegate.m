//
//  FlutterZoomSdkPlugin+UserServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+UserServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation FlutterZoomSdkPlugin  (UserServiceDelegate)

#pragma mark - User Service Delegate

- (void)onMyHandStateChange
{
    NSLog(@"MobileRTC onMyHandStateChange");
}

- (void)onSinkMeetingUserJoin:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingUserJoin==%@", @(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingUserJoin:userID];
    }
}

- (void)onSinkMeetingUserLeft:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingUserLeft==%@", @(userID));
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetingUserInfo *leftUser = [ms userInfoByID:userID];
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingUserLeft:userID];
    }
}

#pragma mark - In meeting users' state updated
- (void)onInMeetingUserUpdated
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *users = [ms getInMeetingUserList];
    NSLog(@"MobileRTC onInMeetingUserUpdated:%@", users);
}

- (void)onInMeetingChat:(NSString *)messageID
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSLog(@"MobileRTC onInMeetingChat:%@ content:%@", messageID, [ms meetingChatByID:messageID]);
    MobileRTCMeetingChat *chat = [ms meetingChatByID:messageID];
    NSLog(@"MobileRTC MobileRTCMeetingChat-->%@",chat);
}

- (void)onSinkUserNameChanged:(NSUInteger)userID userName:(NSString *_Nonnull)userName
{
    NSLog(@"onSinkUserNameChanged:%@ userName:%@", @(userID), userName);
}

- (void)onSinkMeetingUserRaiseHand:(NSUInteger)userID {
    NSLog(@"MobileRTC onSinkMeetingUserRaiseHand==%@", @(userID));
}

- (void)onSinkMeetingUserLowerHand:(NSUInteger)userID {
    NSLog(@"MobileRTC onSinkMeetingUserLowerHand==%@", @(userID));
}

- (void)onMeetingHostChange:(NSUInteger)hostId {
    NSLog(@"MobileRTC onMeetingHostChange==%@", @(hostId));
}

- (void)onMeetingCoHostChange:(NSUInteger)cohostId {
    NSLog(@"MobileRTC onMeetingCoHostChange==%@", @(cohostId));
}

- (void)onClaimHostResult:(MobileRTCClaimHostError)error
{
    NSLog(@"MobileRTC onClaimHostResult==%@", @(error));
}

@end
