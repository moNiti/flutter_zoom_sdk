//
//  FlutterZoomSdkPlugin+VideoServiceDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+VideoServiceDelegate.h"
#import "CustomMeetingViewController+MeetingDelegate.h"

@implementation FlutterZoomSdkPlugin (VideoServiceDelegate)

#pragma mark - Video Service Delegate

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingActiveVideo =>%@", @(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingActiveVideo:userID];
    }
}

- (void)onSinkMeetingPreviewStopped
{
    NSLog(@"MobileRTC onSinkMeetingPreviewStopped");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingPreviewStopped];
    }
}


- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingVideoStatusChange=%@",@(userID));
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onSinkMeetingVideoStatusChange:userID];
    }
}

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID videoStatus:(MobileRTC_VideoStatus)videoStatus
{
    NSLog(@"MobileRTC onSinkMeetingVideoStatusChange=%@, videoStatus=%@",@(userID), @(videoStatus));
}

- (void)onMyVideoStateChange
{
    NSLog(@"MobileRTC onMyVideoStateChange");
    if (self.customMeetingVC)
    {
        [self.customMeetingVC onMyVideoStateChange];
    }
}

- (void)onSinkMeetingVideoQualityChanged:(MobileRTCNetworkQuality)qality userID:(NSUInteger)userID
{
    NSLog(@"MobileRTC onSinkMeetingVideoQualityChanged: %zd userID:%zd",qality,userID);
}

- (void)onSinkMeetingVideoRequestUnmuteByHost:(void (^)(BOOL Accept))completion
{
    NSLog(@"MobileRTC onSinkMeetingVideoRequestUnmuteByHost");
//    if (completion)
//    {
//        completion(YES);
//    }
}

- (void)onVideoOrderUpdated:(NSArray <NSNumber *>* _Nullable)orderArr;
{
    NSLog(@"[Video Order] callback onVideoOrderUpdated: %@", orderArr);
}

- (void)onFollowHostVideoOrderChanged:(BOOL)follow;
{
    NSLog(@"[Video Order] callback onFollowHostVideoOrderChanged: %@", @(follow));
}

@end
