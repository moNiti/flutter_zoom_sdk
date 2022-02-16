//
//  CustomMeetingViewController+MeetingDelegate.h
//  Pods
//
//  Created by Niti Jirakarnwuttikrai on 14/2/2565 BE.
//

#import "CustomMeetingViewController.h"

@interface CustomMeetingViewController (MeetingDelegate)

- (void)onMeetingStateChange:(MobileRTCMeetingState)state;

- (void)onSinkMeetingActiveVideo:(NSUInteger)userID;

- (void)onSinkMeetingAudioStatusChange:(NSUInteger)userID;

- (void)onSinkMeetingMyAudioTypeChange;

- (void)onSinkMeetingVideoStatusChange:(NSUInteger)userID;

- (void)onMyVideoStateChange;

- (void)onSinkMeetingUserJoin:(NSUInteger)userID;

- (void)onSinkMeetingUserLeft:(NSUInteger)userID;

- (void)onSinkMeetingActiveShare:(NSUInteger)userID;

- (void)onSinkShareSizeChange:(NSUInteger)userID;

- (void)onSinkMeetingShareReceiving:(NSUInteger)userID;

- (void)onWaitingRoomStatusChange:(BOOL)needWaiting;

- (void)onSinkMeetingPreviewStopped;

@end



