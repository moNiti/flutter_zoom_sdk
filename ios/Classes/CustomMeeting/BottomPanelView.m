//
//  BottomPanelView.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2018/10/12.
//  Copyright © 2018 Zoom Video Communications, Inc. All rights reserved.
//

#import "BottomPanelView.h"
#import "SDKAudioPresenter.h"
#import "SDKVideoPresenter.h"
#import "SDKSharePresenter.h"
#import "SDKActionPresenter.h"
#import "QAListViewController.h"
#import "BOMeetingViewController.h"
#import "VBViewController.h"
#import "CameraCaptureAdapter.h"
#import "SendPictureAdapter.h"
#import "SendYUVAdapter.h"
#import "SelectLanguageViewController.h"
#import "ManageLanInterpreViewController.h"
#import "InterpreterLanguageSelectViewController.h"
#import "WebinarAtteedeeslistViewController.h"
#import "Sample-Prefix.h"
#import "FlutterZoomSdkPlugin.h"


@interface BottomPanelView ()
@property (strong, nonatomic)  CAGradientLayer      *gradientLayer;
@property (strong, nonatomic)  UIButton             *audioButton;
@property (strong, nonatomic)  UIButton             *videoButton;
@property (strong, nonatomic)  UIButton             *voteButton;
@property (strong, nonatomic)  UIButton             *chatButton;
@property (strong, nonatomic)  UIButton             *moreButton;

// Presenter
@property (strong, nonatomic) SDKAudioPresenter           *audioPresenter;
@property (strong, nonatomic) SDKVideoPresenter           *videoPresenter;
@property (strong, nonatomic) SDKSharePresenter           *sharePresenter;
@property (strong, nonatomic) SDKActionPresenter          *actionPresenter;

@property (nonatomic,strong) CameraCaptureAdapter *cameraAdapter;
@property (nonatomic,strong) SendPictureAdapter *picAdapter;
@property (nonatomic,strong) SendYUVAdapter     *yuvAdapter;

@property (nonatomic, strong) MobileRTCVideoSourceHelper *videoSourceHelper;
@property (nonatomic, assign) BOOL isRaiseHand;

@property (nonatomic, assign) BOOL firstSendChat;;
@end

@implementation BottomPanelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.frame = self.bounds;
        [self.layer addSublayer:self.gradientLayer];
        self.gradientLayer.startPoint = CGPointMake(0.5, 1);
        self.gradientLayer.endPoint = CGPointMake(0.5, 0);
        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithWhite:0.f alpha:0.8].CGColor,
                                      (__bridge id)[UIColor colorWithWhite:0.f alpha:0.2].CGColor];
        
        [self addSubview:self.audioButton];
        [self addSubview:self.videoButton];
        [self addSubview:self.voteButton];
        [self addSubview:self.chatButton];
        [self addSubview:self.moreButton];
        
        if ([[MobileRTC sharedRTC] hasRawDataLicense]) {
            self.videoSourceHelper = [[MobileRTCVideoSourceHelper alloc] init];
        }
        
        _firstSendChat = YES;
    }
    return self;
}

- (void)showBottomPanelView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-Bottom_Height, [UIScreen mainScreen].bounds.size.width, Bottom_Height);
    } completion:^(BOOL finished) {
    }];
}

- (void)hiddenBottomPanelView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, Bottom_Height);
    } completion:^(BOOL finished) {
    }];
}

- (void)updateFrame
{
    CGFloat panelWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-Bottom_Height, panelWidth, Bottom_Height);
    self.gradientLayer.frame = self.bounds;
    
    float bottomButtonHeight = IPHONE_X ? 60 : Bottom_Height;
    
    self.audioButton.frame = CGRectMake(0, 0, panelWidth/5, bottomButtonHeight);
    [self.audioButton setTitleEdgeInsets:UIEdgeInsetsMake(_audioButton.imageView.frame.size.height ,-self.audioButton.imageView.frame.size.width, 0.0,0.0)];
    [self.audioButton setImageEdgeInsets:UIEdgeInsetsMake(-self.audioButton.imageView.frame.size.height/2, 0.0,0.0, -self.audioButton.titleLabel.bounds.size.width)];
    
    self.videoButton.frame = CGRectMake(panelWidth*1/5, 0, panelWidth/5, bottomButtonHeight);
    [self.videoButton setTitleEdgeInsets:UIEdgeInsetsMake(self.videoButton.imageView.frame.size.height ,-self.videoButton.imageView.frame.size.width, 0.0,0.0)];
    [self.videoButton setImageEdgeInsets:UIEdgeInsetsMake(-self.videoButton.imageView.frame.size.height/2, 0.0,0.0, -self.videoButton.titleLabel.bounds.size.width)];
    
    self.voteButton.frame = CGRectMake(panelWidth*2/5, 0, panelWidth/5, bottomButtonHeight);
    [self.voteButton setTitleEdgeInsets:UIEdgeInsetsMake(self.voteButton.imageView.frame.size.height ,-self.voteButton.imageView.frame.size.width, 0.0,0.0)];
    [self.voteButton setImageEdgeInsets:UIEdgeInsetsMake(-self.voteButton.imageView.frame.size.height/2, 0.0,0.0, -self.voteButton.titleLabel.bounds.size.width)];
    
    self.chatButton.frame = CGRectMake(panelWidth*3/5, 0, panelWidth/5, bottomButtonHeight);
    [self.chatButton setTitleEdgeInsets:UIEdgeInsetsMake(self.chatButton.imageView.frame.size.height ,-self.chatButton.imageView.frame.size.width, 0.0,0.0)];
    [self.chatButton setImageEdgeInsets:UIEdgeInsetsMake(-self.chatButton.imageView.frame.size.height/2, 0.0,0.0, -self.chatButton.titleLabel.bounds.size.width)];
    
    self.moreButton.frame = CGRectMake(panelWidth*4/5, 0, panelWidth/5, bottomButtonHeight);
    [self.moreButton setTitleEdgeInsets:UIEdgeInsetsMake(self.moreButton.imageView.frame.size.height ,-self.moreButton.imageView.frame.size.width, 0.0,0.0)];
    [self.moreButton setImageEdgeInsets:UIEdgeInsetsMake(-self.moreButton.imageView.frame.size.height/2, 0.0,0.0, -self.moreButton.titleLabel.bounds.size.width)];
}


- (void)dealloc {
    self.gradientLayer = nil;
    self.audioButton = nil;
    self.videoButton = nil;
    self.voteButton = nil;
    self.chatButton = nil;
    self.moreButton = nil;
    
    self.audioPresenter = nil;
    self.videoPresenter = nil;
    self.sharePresenter = nil;
    self.actionPresenter = nil;
    
    self.videoSourceHelper = nil;
}


- (UIButton*)audioButton
{
    if (!_audioButton)
    {
        _audioButton = [[UIButton alloc] init];
        
        if([self.audioPresenter isMute]) {
            [self.audioButton setImage:[UIImage imageNamed:@"icon_meeting_audio_mute"] forState:UIControlStateNormal];
            [self.audioButton setTitle:@"Unmute" forState:UIControlStateNormal];
        }
        else {
            [_audioButton setImage:[UIImage imageNamed:@"icon_meeting_audio"] forState:UIControlStateNormal];
            [_audioButton setTitle:@"Mute" forState:UIControlStateNormal];
        }
        _audioButton.tag = kTagButtonAudio;
        [_audioButton addTarget: self action: @selector(onBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _audioButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _audioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
    }
    return _audioButton;
}

- (UIButton*)videoButton
{
    if (!_videoButton)
    {
        _videoButton = [[UIButton alloc] init];
        if(![self.videoPresenter isOnCamera])
        {
            [self.videoButton setImage:[UIImage imageNamed:@"icon_meeting_video_mute"] forState:UIControlStateNormal];
            [self.videoButton setTitle:@"Start Video" forState:UIControlStateNormal];
        }
        else
        {
            [self.videoButton setImage:[UIImage imageNamed:@"icon_meeting_video"] forState:UIControlStateNormal];
            [self.videoButton setTitle:@"Stop Video" forState:UIControlStateNormal];
        }
        
        _videoButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _videoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _videoButton.tag = kTagButtonVideo;
        [_videoButton addTarget: self action: @selector(onBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _videoButton;
}


- (UIButton*)voteButton
{
    if (!_voteButton)
    {
        _voteButton = [[UIButton alloc] init];
        [_voteButton setImage:[UIImage imageNamed:@"icon_meeting_share"] forState:UIControlStateNormal];
        [_voteButton setTitle:@"ลงคะแนนเสียง" forState:UIControlStateNormal];
        _voteButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _voteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _voteButton.tag = kTagButtonVote;
        [_voteButton addTarget: self action: @selector(onBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _voteButton;
}


- (UIButton*)chatButton
{
    if (!_chatButton)
    {
        _chatButton = [[UIButton alloc] init];
        [_chatButton setImage:[UIImage imageNamed:@"icon_meeting_attendee"] forState:UIControlStateNormal];
        [_chatButton setTitle:@"Chat" forState:UIControlStateNormal];
        _chatButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _chatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _chatButton.tag = kTagButtonChat;
        [_chatButton addTarget: self action: @selector(onBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _chatButton;
}

- (UIButton*)moreButton
{
    if (!_moreButton)
    {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"icon_meeting_more"] forState:UIControlStateNormal];
        [_moreButton setTitle:@"More" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
        _moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _moreButton.tag = kTagButtonMore;
        [_moreButton addTarget: self action: @selector(onBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _moreButton;
}

- (SDKAudioPresenter *)audioPresenter
{
    if (!_audioPresenter)
    {
        _audioPresenter = [[SDKAudioPresenter alloc] init];
    }
    
    return _audioPresenter;
}

- (SDKVideoPresenter *)videoPresenter
{
    if (!_videoPresenter)
    {
        _videoPresenter = [[SDKVideoPresenter alloc] init];
    }
    
    return _videoPresenter;
}

- (SDKSharePresenter *)sharePresenter
{
    if (!_sharePresenter)
    {
        _sharePresenter = [[SDKSharePresenter alloc] init];
    }
    
    return _sharePresenter;
}

- (SDKActionPresenter *)actionPresenter
{
    if (!_actionPresenter)
    {
        _actionPresenter = [[SDKActionPresenter alloc] init];
    }
    
    return _actionPresenter;
}

- (void)onBarButtonClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case kTagButtonAudio:
        {
            [self.audioPresenter muteMyAudio];
            [self updateMyAudioStatus];
            break;
        }
        case kTagButtonVideo:
        {
            [self.videoPresenter muteMyVideo];
            [self updateMyVideoStatus];
            break;
        }
        case kTagButtonVote:
        {
            [FlutterZoomSdkPlugin openVote];
            break;
        }
        case kTagButtonChat:
        {
            [self.actionPresenter presentChatViewController];
            break;
        }
        case kTagButtonMore:
        {
            [self onMoreButtonClicked:sender];
        }
        
        default:
            break;
    }
}

- (void)onMoreButtonClicked:(id)sender
{
    NSString * meetingTypeString;
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetingType type = [ms getMeetingType];
    switch (type) {
        case MobileRTCMeetingType_None:
            meetingTypeString = @"MeetingType:None";
            break;
        case MobileRTCMeetingType_Normal:
            meetingTypeString = @"MeetingType:Normal";
            break;
        case MobileRTCMeetingType_BreakoutRoom:
            meetingTypeString = @"MeetingType:BreakoutRoom";
            break;
        case MobileRTCMeetingType_Webinar:
            meetingTypeString = @"MeetingType:Webinar";
            break;
        default:
            meetingTypeString = @"MeetingType:None";
            break;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:meetingTypeString
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    if (![ms isMeetingHost]
        && ![ms isInterpreter]
        && [ms isInterpretationStarted]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Select Language"
          style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *action) {
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;


            SelectLanguageViewController *VC = [[SelectLanguageViewController alloc] init];
            VC.currentLanID = [ms getJoinedLanguageID];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [ topViewController presentViewController:nav animated:YES completion:NULL];
        }]];
    }
    
    
    if ([ms isMeetingHost]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Manage LanInterpre"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

                                                                   

                                                                    ManageLanInterpreViewController *VC = [[ManageLanInterpreViewController alloc] init];
                                                                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
                                                                    nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                                                    [ topViewController presentViewController:nav animated:YES completion:NULL];
                                                                }]];
    }
    
    if ([ms isInterpreter]
        && [ms isInterpretationStarted]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Interpreter Language Select"
          style:UIAlertActionStyleDefault
        handler:^(UIAlertAction *action) {
//            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

            InterpreterLanguageSelectViewController *VC = [[InterpreterLanguageSelectViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [ topViewController presentViewController:nav animated:YES completion:NULL];
        }]];
    }
    
    if ([ms isBOMeetingEnabled]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"BO Meeting"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;


                                                              BOMeetingViewController *VC = [[BOMeetingViewController alloc] init];
                                                              UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
                                                              nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                                              [ topViewController presentViewController:nav animated:YES completion:NULL];
                                                          }]];
    }
    
//    if ([ms isSupportVirtualBG]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Virtual Background"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction *action) {
////                                                              AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//
//
//                                                              VBViewController *VC = [[VBViewController alloc] init];
//                                                              UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
//                                                              nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                                                              [ topViewController presentViewController:nav animated:YES completion:NULL];
//                                                          }]];
//    }
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Switch My Audio"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction *action) {
//                                                          [self.audioPresenter switchMyAudioSource];
//                                                      }]];

    if (ms)
    {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Dialing Room"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction *action) {
//                                                            [self dialRoomFunction];
//                                                          }]];
        
        MobileRTCAudioType audioType = [self.audioPresenter myAudioType];
        if (audioType != MobileRTCAudioType_None)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Disconnect Audio"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                [self.audioPresenter connectMyAudio:NO];
                                                              }]];
        }
        
//        if (ms.isMeetingHost || ms.isMeetingCoHost) {
//            NSString *meetingLockTitle = ms.isMeetingLocked ? @"Unlock Meeting":@"Lock Meeting";
//            [alertController addAction:[UIAlertAction actionWithTitle:meetingLockTitle
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  [self.actionPresenter lockMeeting];
//                                                              }]];
//            NSString *meetingShareLocktitle = ms.isShareLocked ? @"Unlock Share":@"Lock Share";
//            [alertController addAction:[UIAlertAction actionWithTitle:meetingShareLocktitle
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  [self.actionPresenter lockShare];
//                                                              }]];
//        }
        
//        MobileRTCAnnotationService *as = [[MobileRTC sharedRTC] getAnnotationService];
//        if ([as canDisableViewerAnnoataion]) {
//            if ([as isViewerAnnoataionDisabled]) {
//                [alertController addAction:[UIAlertAction actionWithTitle:@"Allow Viewer Annotation"
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction *action) {
//                                                                      [as disableViewerAnnoataion:NO];
//                                                                  }]];
//            } else {
//                [alertController addAction:[UIAlertAction actionWithTitle:@"Disable Viewer Annotation"
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction *action) {
//                                                                      [as disableViewerAnnoataion:YES];
//                                                                  }]];
//            }
//        }
        MobileRTCWaitingRoomService *ws = [[MobileRTC sharedRTC] getWaitingRoomService];
//        if ([ws isSupportWaitingRoom] && ([ms isMeetingHost] || [ms isMeetingCoHost])) {
//            if ([ws isWaitingRoomOnEntryFlagOn]) {
//                [alertController addAction:[UIAlertAction actionWithTitle:@"Disable Waiting Room On Entry"
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction *action) {
//                                                                      [ws enableWaitingRoomOnEntry:NO];
//                                                                  }]];
//            } else {
//                [alertController addAction:[UIAlertAction actionWithTitle:@"Enable Waiting Room On Entry"
//                                                                    style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction *action) {
//                                                                      [ws enableWaitingRoomOnEntry:YES];
//                                                                  }]];
//            }
//        }
//
//        if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Change Chat Priviledge"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  [self changeChatPriviledge:sender];
//                                                              }]];
//        }
        
//        BOOL hasLicense = [[MobileRTC sharedRTC] hasRawDataLicense];
//        if (hasLicense) {
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Send Rawdata - Camera Data"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                self.cameraAdapter = [[CameraCaptureAdapter alloc] init];
//                [self.videoSourceHelper setExternalVideoSource:self.cameraAdapter];
//            }]];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Send Rawdata - Picture Data"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction *action) {
//                self.picAdapter = [[SendPictureAdapter alloc] init];
//                [self.videoSourceHelper setExternalVideoSource:self.picAdapter];
//            }]];
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Send Rawdata - YUV Data"
//                                                            style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction *action) {
//                self.yuvAdapter = [[SendYUVAdapter alloc] init];
//                [self.videoSourceHelper setExternalVideoSource:self.yuvAdapter];
//            }]];
//
//
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Switch to internal video source"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                                                                  [self.videoSourceHelper setExternalVideoSource:nil];
//                                                              }]];
//
//        }
    }
    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Show ANN Pannel"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction *action) {
//        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
//        [ms showAANPanelInView:self.superview originPoint:CGPointMake(20, 60)];
//    }]];
    
//    if ([ms isMeetingHost] && [ms isCMREnabled]) {
//        if (![ms isCMRInProgress]) {
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recording"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                [ms turnOnCMR:YES];
//            }]];
//        } else {
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Stop Recording"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                [ms turnOnCMR:NO];
//            }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Pause/Resume Recording"
//                                                                style:UIAlertActionStyleDefault
//                                                              handler:^(UIAlertAction *action) {
//                [ms resumePauseCMR];
//            }]];
//        }
//    }
    
    NSString *raiseHandString = _isRaiseHand ? @"Lower My Hand" : @"Raise My Hand";
    [alertController addAction:[UIAlertAction actionWithTitle:raiseHandString
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        _isRaiseHand ? [ms lowerHand:[ms myselfUserID]] : [ms raiseMyHand];
                                                        _isRaiseHand = !_isRaiseHand;
                                                    }]];
    
    if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Lower All Hand"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ms lowerAllHand];
                                                        }]];
    }
    
//    if ([ms isEmojiReactionEnabled]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Send reaction"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//                                                            [ms sendEmojiReaction:MobileRTCEmojiReactionType_Clap reactionSkinTone:MobileRTCEmojiReactionSkinTone_Default];
//                                                        }]];
//    }
    
//    if (![ms isChatDisabled]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Send a group chat message to all"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//            MobileRTCSendChatError error = [ms sendChatToGroup:MobileRTCChatGroup_All WithContent:@"This is a group chat message that send to all"];
//            NSLog(@"SendChat:sendChatToGroup ---> %@", @(error));
//
//            if (error == MobileRTCSendChatError_Successed && _firstSendChat == YES) {
//                if ([ms isMeetingChatLegalNoticeAvailable]) {
//                    _firstSendChat = NO;
//                    NSString *LegalNoticePromoteTitle = [ms getChatLegalNoticesPrompt];
//                    NSString *LegalNoticePromoteExplained = [ms getChatLegalNoticesExplained];
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LegalNoticePromoteTitle message:LegalNoticePromoteExplained delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//            }
//
//                                                        }]];
//        if ([ms isWebinarMeeting]) {
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Send a group chat message to Panelists"
//                                                              style:UIAlertActionStyleDefault
//                                                            handler:^(UIAlertAction *action) {
//                MobileRTCSendChatError error = [ms sendChatToGroup:MobileRTCChatGroup_Panelists WithContent:@"This is a group chat message that send to Panelists"];
//                NSLog(@"SendChat:sendChatToGroup ---> %@", @(error));
//                                                            }]];
//        } else {
//            if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
//                [alertController addAction:[UIAlertAction actionWithTitle:@"Send a group chat message to Waiting Room"
//                                                                  style:UIAlertActionStyleDefault
//                                                                handler:^(UIAlertAction *action) {
//                    MobileRTCSendChatError error = [ms sendChatToGroup:MobileRTCChatGroup_WaitingRoomUsers WithContent:@"This is a group chat message that send to Waiting Room"];
//                    NSLog(@"SendChat:sendChatToGroup ---> %@", @(error));
//
//                                                                }]];
//            }
//
//        }
//    }
    
    if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
        NSString *muteOnEntryString = [ms isMuteOnEntryOn] ? @"UnMute Participants upon Entry" : @"Mute Participants upon Entry";
        [alertController addAction:[UIAlertAction actionWithTitle:muteOnEntryString
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ms muteOnEntry:![ms isMuteOnEntryOn]];
                                                        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Mute All"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ms muteAllUserAudio:YES];
                                                        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ask All UnMute"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ms askAllToUnmute];
                                                        }]];
        
        NSString *playChimeString = [ms isPlayChimeOn] ? @"Does not Play Sound When Someone Join/Leave" : @"Play Sound When Someone Join/Leave";
        [alertController addAction:[UIAlertAction actionWithTitle:playChimeString
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [ms playChime:![ms isPlayChimeOn]];
                                                        }]];
    }
    
//    if ([ms canClaimhost]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"Claim host"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//                                                            [self ClaimHostWitHostKey];
//                                                        }]];
//    }
    
    if ([ms isWebinarMeeting]) {
        if ([ms isQAEnabled]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"QA"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
//                                                                  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [[[MobileRTC sharedRTC] getMeetingService] presentQAViewController:topViewController];
//                                                                  QAListViewController *VC = [[QAListViewController alloc] init];
//                                                                  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
//                                                                  nav.modalPresentationStyle = UIModalPresentationFullScreen;
//                                                                  [ topViewController presentViewController:nav animated:YES completion:NULL];
                                                              }]];
        }
        
        if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
//            NSString *allowPanelistStartVideoString = [ms isAllowPanelistStartVideo] ? @"Does not Allow Panelist Start Video" : @"Allow Panelist Start Video";
//            [alertController addAction:[UIAlertAction actionWithTitle:allowPanelistStartVideoString
//                                                                        style:UIAlertActionStyleDefault
//                                                                        handler:^(UIAlertAction *action) {
//                                                                            [ms allowPanelistStartVideo:![ms isAllowPanelistStartVideo]];
//                                                                        }]];
//
            [alertController addAction:[UIAlertAction actionWithTitle:@"Show Webinar Attendees List"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
//                                                                        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;


                                                                        WebinarAtteedeeslistViewController *VC = [[WebinarAtteedeeslistViewController alloc] init];
                                                                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
                                                                        nav.modalPresentationStyle = UIModalPresentationFullScreen;
                                                                        [ topViewController presentViewController:nav animated:YES completion:NULL];
                                                                    }]];
        }
        
    }
    
//    if ([ms isMeetingHost]) {
//        [alertController addAction:[UIAlertAction actionWithTitle:@"start live stream"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//                                                            [ms startLiveStreamWithStreamingURL:@"" StreamingKey:@"" BroadcastURL:@""];
//                                                        }]];
//
//        [alertController addAction:[UIAlertAction actionWithTitle:@"stop live stream"
//                                                          style:UIAlertActionStyleDefault
//                                                        handler:^(UIAlertAction *action) {
//                                                            [ms stopLiveStream];
//                                                        }]];
//    }
    
    if(![ms isWebinarAttendee]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Participants"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
//                                                                  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [[[MobileRTC sharedRTC] getMeetingService] presentParticipantsViewController:topViewController]; }]];
    }
    
//    ADDITIONAL FOR LIVLY
//    [alertController addAction:[UIAlertAction actionWithTitle:@"ลงคะแนนเสียง"
//                                                        style:UIAlertActionStyleDefault
//                                                      handler:^(UIAlertAction *action) {
//        [FlutterZoomSdkPlugin openVote];
        
//    }]];
    
#pragma live transcription demo
    NSLog(@"LiveTranscription: isMeetingSupportCC===>%@", @([ms isMeetingSupportCC]));
    NSLog(@"LiveTranscription: isLiveTranscriptionFeatureEnabled===>%@", @([ms isLiveTranscriptionFeatureEnabled]));
    NSLog(@"LiveTranscription: canStartLiveTranscription===>%@", @([ms canStartLiveTranscription]));
    NSLog(@"LiveTranscription: isRequestToStartLiveTranscriptionEnabled===>%@", @([ms isRequestToStartLiveTranscriptionEnabled]));
    if([ms isMeetingSupportCC] && [ms isLiveTranscriptionFeatureEnabled]) {
        MobileRTCLiveTranscriptionStatus status = [ms getLiveTranscriptionStatus];
        NSLog(@"LiveTranscription: MobileRTCLiveTranscriptionStatus===>%@", @(status));
        
        if ([ms isMeetingHost]) {
            if ([ms canStartLiveTranscription]) {
                if (MobileRTC_LiveTranscription_Status_Stop == status) {
                    [alertController addAction:[UIAlertAction actionWithTitle:@"start live transcription"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        BOOL ret = [ms startLiveTranscription];
                                                                        NSLog(@"LiveTranscription: startLiveTranscription===>%@",@(ret));
                                                                    }]];
                } else if (MobileRTC_LiveTranscription_Status_Start == status) {
                    [alertController addAction:[UIAlertAction actionWithTitle:@"LiveTranscription: stop live transcription"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        BOOL ret = [ms stopLiveTranscription];
                                                                        NSLog(@"LiveTranscription: stopLiveTranscription===>%@",@(ret));
                                                                    }]];
                }
            }
            
            NSString *enableRequestToStartLiveTranscriptionString = [ms isRequestToStartLiveTranscriptionEnabled] ? @"unenable Request to start live transcription" : @"enable Request to start live transcription";
            [alertController addAction:[UIAlertAction actionWithTitle:enableRequestToStartLiveTranscriptionString
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                BOOL ret = [ms enableRequestLiveTranscription:![ms isRequestToStartLiveTranscriptionEnabled]];
                                                                NSLog(@"LiveTranscription: enableRequestLiveTranscription===>%@",@(ret));
                                                            }]];
        }

        if (![ms isMeetingHost]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"LiveTranscription: request to start live transcription"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                BOOL ret = [ms requestToStartLiveTranscription:YES];
                                                                NSLog(@"LiveTranscription: requestToStartLiveTranscription===>%@",@(ret));
                                                            }]];
        }
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        UIButton *btn = (UIButton*)sender;
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (void)ClaimHostWitHostKey {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Claim Host Wit HostKey"
                                                                   message:@"Input host key"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                                NSString *hostKey = alert.textFields[0].text;
                                                                if (hostKey.length == 0) return;
                                                                [[[MobileRTC sharedRTC] getMeetingService] claimHostWithHostKey:hostKey];
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                            
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"host key";
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [ topViewController presentViewController:alert animated:YES completion:nil];
}

- (void)changeChatPriviledge:(UIButton *)sender
{
    if ([[[MobileRTC sharedRTC] getMeetingService] isWebinarMeeting]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Allow attendees to chat with"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No one"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms allowAttendeeChat:MobileRTCChatAllowAttendeeChat_ChatWithNone];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Panelists"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms allowAttendeeChat:MobileRTCChatAllowAttendeeChat_ChatWithPanelist];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Panelists and Attendees"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms allowAttendeeChat:MobileRTCChatAllowAttendeeChat_ChatWithAll];
                                                          }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = sender;
            popover.sourceRect = sender.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        [controller presentViewController:alertController animated:YES completion:nil];
        
    } else {
        MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
        MobileRTCMeetingChatPriviledgeType priviledgeType  = [ms getAttendeeChatPriviledge];
        NSString *title = @"";
        switch (priviledgeType) {
            case MobileRTCMeetingChatPriviledge_No_One:
                title = [NSString stringWithFormat:@"Allow Participants to Chat with: %@", @"No one"];
                break;
            case MobileRTCMeetingChatPriviledge_Host_Only:
                title = [NSString stringWithFormat:@"Allow Participants to Chat with: %@", @"Host Only"];
                break;
            case MobileRTCMeetingChatPriviledge_Everyone_Publicly:
                title = [NSString stringWithFormat:@"Allow Participants to Chat with: %@", @"Everyone Publicly"];
                break;
            case MobileRTCMeetingChatPriviledge_Everyone_Publicly_And_Privately:
                title = [NSString stringWithFormat:@"Allow Participants to Chat with: %@", @"Everyone Publicly And Privately"];
                break;
            default:
                break;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"No one"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms changeAttendeeChatPriviledge:MobileRTCMeetingChatPriviledge_No_One];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Host Only"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms changeAttendeeChatPriviledge:MobileRTCMeetingChatPriviledge_Host_Only];
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Everyone Publicly"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [ms changeAttendeeChatPriviledge:MobileRTCMeetingChatPriviledge_Everyone_Publicly];
                                                          }]];
        if (![ms isPrivateChatDisabled]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Everyone Publicly And Privately"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {
                                                                  [ms changeAttendeeChatPriviledge:MobileRTCMeetingChatPriviledge_Everyone_Publicly_And_Privately];
                                                              }]];
        }
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        if (popover)
        {
            popover.sourceView = sender;
            popover.sourceRect = sender.bounds;
            popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        }
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        [controller presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)updateMyAudioStatus
{
    NSLog(@"=>>>>>> UPDATE MY AUDIO STATUS");
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) return;
    
    MobileRTCAudioType audioType = [ms myAudioType];
    if (audioType == MobileRTCAudioType_None)
    {
        [self.audioButton setImage:[UIImage imageNamed:@"icon_meeting_noaudio"] forState:UIControlStateNormal];
        [self.audioButton setTitle:@"Join Audio" forState:UIControlStateNormal];
    }
    else
    {
        if([ms isMyAudioMuted])
        {
            [self.audioButton setImage:[UIImage imageNamed:@"icon_meeting_audio_mute"] forState:UIControlStateNormal];
            [self.audioButton setTitle:@"Unmute" forState:UIControlStateNormal];

        }
        else
        {
            if (audioType == MobileRTCAudioType_Telephony) {
                [self.audioButton setImage:[UIImage imageNamed:@"icon_meeting_audio_phone"] forState:UIControlStateNormal];
                [self.audioButton setTitle:@"Mute" forState:UIControlStateNormal];
            } else {
                [self.audioButton setImage:[UIImage imageNamed:@"icon_meeting_audio"] forState:UIControlStateNormal];
                [self.audioButton setTitle:@"Mute" forState:UIControlStateNormal];
            }

        }
    }
    [self.audioButton setTitleEdgeInsets:UIEdgeInsetsMake(self.audioButton.imageView.frame.size.height ,-self.audioButton.imageView.frame.size.width, 0.0,0.0)];
    [self.audioButton setImageEdgeInsets:UIEdgeInsetsMake(-self.audioButton.imageView.frame.size.height/2, 0.0,0.0, -self.audioButton.titleLabel.bounds.size.width)];
}

- (void)updateMyVideoStatus
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (!ms) return;
    
    BOOL sendingMyVideo = [ms isSendingMyVideo];
    if(!sendingMyVideo)
    {
        NSLog(@"=>>>>>>1 UPDATE MY VIDEO STATUS");
        [self.videoButton setImage:[UIImage imageNamed:@"icon_meeting_video_mute"] forState:UIControlStateNormal];
        [self.videoButton setTitle:@"Start Video" forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"=>>>>>2 UPDATE MY VIDEO STATUS");
        [self.videoButton setImage:[UIImage imageNamed:@"icon_meeting_video"] forState:UIControlStateNormal];
        [self.videoButton setTitle:@"Stop Video" forState:UIControlStateNormal];
    }
    [self.videoButton setTitleEdgeInsets:UIEdgeInsetsMake(self.videoButton.imageView.frame.size.height ,-self.videoButton.imageView.frame.size.width, 0.0,0.0)];
    [self.videoButton setImageEdgeInsets:UIEdgeInsetsMake(-self.videoButton.imageView.frame.size.height/2, 0.0,0.0, -self.videoButton.titleLabel.bounds.size.width)];
}

- (void)dialRoomFunction {
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *roomList = [ms getRoomDeviceList];
    NSArray *ipList = [ms getIPAddressList];
    NSLog(@"roomList: %@", roomList);
    MobileRTCRoomDevice *room = [[MobileRTCRoomDevice alloc] init];

    
    BOOL ret = [ms callRoomDevice:room];
    NSLog(@"call room : %@", @(ret));
}


@end
