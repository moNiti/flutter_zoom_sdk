//
//  CustomMeetingViewController.h
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 27/1/2565 BE.
//

#import <MobileRTC/MobileRTC.h>
#import <UIKit/UIKit.h>
#import "TopPanelView.h"
#import "BottomPanelView.h"
#import "ThumbTableViewCell.h"
#import "ThumbView.h"
#import "RemoteShareViewController.h"
#import "LocalShareViewController.h"
#import "VideoViewController.h"
#import "AnnoFloatBarView.h"
#import "Sample-Prefix.h"
#import "SDKActionPresenter.h"


@interface CustomMeetingViewController : UIViewController

@property (strong, nonatomic) UIView                    * baseView;
@property (strong, nonatomic) TopPanelView              * topPanelView;
@property (strong, nonatomic) BottomPanelView           * bottomPanelView;
@property (strong, nonatomic) ThumbView                 * thumbView;
@property (nonatomic)         BOOL                      isShowTopBottonPanel;

@property (assign, nonatomic) BOOL                      isFullScreenMode;
@property (assign, nonatomic) NSInteger                 pinUserId;
@property (assign, nonatomic) CGAffineTransform         oriTransform;
@property (strong, nonatomic) UIPanGestureRecognizer    * panGesture;

@property (strong, nonatomic) NSMutableArray                * vcArray;
@property (strong, nonatomic) VideoViewController           * videoVC;
@property (strong, nonatomic) RemoteShareViewController     * remoteShareVC;
@property (strong, nonatomic) LocalShareViewController      * localShareVC;

@property (strong, nonatomic) AnnoFloatBarView * annoFloatBarView;

@property (strong, nonatomic) SDKActionPresenter     *actionPresenter;


- (void)updateVideoOrShare;
- (void)updateMyAudioStatus;
- (void)updateMyVideoStatus;
- (void)updateMyShareStatus;

- (void)showVideoView;
- (void)showRemoteShareView;
- (void)showLocalShareView;
- (void)hideAnnotationView;
@end
