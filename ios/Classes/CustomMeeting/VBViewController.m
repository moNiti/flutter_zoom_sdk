//
//  VBViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2020/4/7.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//
#import <MobileRTC/MobileRTC.h>
#import "VBViewController.h"
#import "Sample-Prefix.h"



@interface VBViewController ()
@property(nonatomic, strong) UIButton *addButton;
@property(nonatomic, strong) UIButton *removeButton;
@property(nonatomic, strong) UIButton *closeButton;
@property(nonatomic, strong) UIButton *useButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UISwitch *greenSwitch;
@property(nonatomic, assign) NSUInteger vbIndex;
@property(nonatomic, assign) BOOL usingGreenVB;
@end

@implementation VBViewController
@synthesize addButton, removeButton, closeButton, useButton, nextButton, greenSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Virtual Background";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    [self.navigationItem.leftBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    BOOL supportVB = [ms isSupportVirtualBG];
    NSLog(@"[VB Test] isSupportVirtualBG : %@.", @(supportVB));
    if (!supportVB) {
        return;
    }
    
    BOOL ret = [ms startPreviewWithFrame:self.view.frame];
    if (!ret) {
        NSLog(@"[VB Test] startPreviewWithFrame, please check camera status.");
        return;
    }
    
    NSLog(@"[VB Test] startPreviewWithFrame success.");
    
    NSLog(@"[VB Test] ms.previewView : %@.", ms.previewView);
    if (ms.previewView) {
        [self.view addSubview:ms.previewView];
    }
    
    NSLog(@"[VB Test] is using the green vb now: %@.", @([ms isUsingGreenVB]));
    
    [self initSubViews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSInteger btnNum = 5;
    CGFloat marginLeft = 12.0;
    CGFloat marginRight = 12.0;
    CGFloat intervalX = 3.0;
    CGFloat buttonW = ((SCREEN_WIDTH - marginLeft - marginRight) - intervalX * (btnNum - 1)) / btnNum;
    CGFloat buttonH = 50.0;
    CGFloat startY = self.view.frame.size.height - 150;
    
    addButton.frame = CGRectMake(marginLeft, startY, buttonW, buttonH);
    removeButton.frame = CGRectMake(marginLeft + buttonW + intervalX, startY, buttonW, buttonH);
    closeButton.frame = CGRectMake(marginLeft + 2*buttonW + 2*intervalX, startY, buttonW, buttonH);
    useButton.frame = CGRectMake(marginLeft + 3*buttonW + 3*intervalX, startY, buttonW, buttonH);
    nextButton.frame = CGRectMake(marginLeft + 4*buttonW + 4*intervalX, startY, buttonW, buttonH);
    greenSwitch.frame = CGRectMake(100, 100, 200, 200);
}

- (void)initSubViews {
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    BOOL ret = [ms isUsingGreenVB];
    BOOL smartVB = [ms isSupportSmartVirtualBG];
    NSLog(@"[VB Test] isUsingGreenVB : %@, isSupportSmartVirtualBG : %@", @(ret), @(smartVB));

    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    [addButton setBackgroundColor:RGBCOLOR(0x66, 0x66, 0x66)];
    [addButton setTitleColor:RGBCOLOR(45, 140, 255) forState:UIControlStateNormal];
    addButton.titleLabel.font = BUTTON_FONT;
    [addButton addTarget:self action:@selector(onAddButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeButton setTitle:NSLocalizedString(@"Remove", @"") forState:UIControlStateNormal];
    [removeButton setBackgroundColor:RGBCOLOR(0x66, 0x66, 0x66)];
    [removeButton setTitleColor:RGBCOLOR(45, 140, 255) forState:UIControlStateNormal];
    removeButton.titleLabel.font = BUTTON_FONT;
    [removeButton addTarget:self action:@selector(onRemoveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:NSLocalizedString(@"Close", @"") forState:UIControlStateNormal];
    [closeButton setBackgroundColor:RGBCOLOR(0x66, 0x66, 0x66)];
    [closeButton setTitleColor:RGBCOLOR(45, 140, 255) forState:UIControlStateNormal];
    closeButton.titleLabel.font = BUTTON_FONT;
    [closeButton addTarget:self action:@selector(onCloseVBButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    useButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [useButton setTitle:NSLocalizedString(@"Use", @"") forState:UIControlStateNormal];
    [useButton setBackgroundColor:RGBCOLOR(0x66, 0x66, 0x66)];
    [useButton setTitleColor:RGBCOLOR(45, 140, 255) forState:UIControlStateNormal];
    useButton.titleLabel.font = BUTTON_FONT;
    [useButton addTarget:self action:@selector(onUseVBButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:NSLocalizedString(@"Next", @"") forState:UIControlStateNormal];
    [nextButton setBackgroundColor:RGBCOLOR(0x66, 0x66, 0x66)];
    [nextButton setTitleColor:RGBCOLOR(45, 140, 255) forState:UIControlStateNormal];
    nextButton.titleLabel.font = BUTTON_FONT;
    [nextButton addTarget:self action:@selector(onNextVBButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    greenSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    greenSwitch.on = [ms isUsingGreenVB];
    [greenSwitch addTarget:self action:@selector(switchOn) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 14.0, *)) {
        greenSwitch.preferredStyle = UISwitchStyleCheckbox;
    } else {
        // Fallback on earlier versions
    }
    
    if (IS_IPAD) {
        [self.view addSubview:greenSwitch];
    }
    [self.view addSubview:addButton];
    [self.view addSubview:removeButton];
    [self.view addSubview:closeButton];
    [self.view addSubview:nextButton];
    [self.view addSubview:useButton];
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)onAddButtonClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if ([ms isSupportSmartVirtualBG]) {
        MobileRTCMeetError ret = [ms addBGImage:[UIImage imageNamed:@"zoom_intro1"]];
        NSLog(@"[VB Test] addBGImage 1 : %@.", @(ret));
        ret = [ms addBGImage:[UIImage imageNamed:@"zoom_intro2"]];
        NSLog(@"[VB Test] addBGImage 2 : %@.", @(ret));
        ret = [ms addBGImage:[UIImage imageNamed:@"zoom_intro3"]];
        NSLog(@"[VB Test] addBGImage 3 : %@.", @(ret));
        ret = [ms addBGImage:[UIImage imageNamed:@"zoom_intro4"]];
        NSLog(@"[VB Test] addBGImage 4 : %@.", @(ret));
    }
}

- (void)onRemoveButtonClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *imgList = [ms getBGImageList];
    if ([ms isSupportSmartVirtualBG]) {
        MobileRTCMeetError ret = [ms removeBGImage:[imgList lastObject]];
        NSLog(@"[VB Test] removeBGImage : %@.", @(ret));
    }
}

- (void)onCloseVBButtonClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if ([ms isSupportSmartVirtualBG]) {
        MobileRTCMeetError ret = [ms useNoneImage];
        NSLog(@"[VB Test] useNoneImage : %@.", @(ret));
    }
}

- (void)switchOn
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    MobileRTCMeetError error = [ms enableGreenVB:greenSwitch.on];
    NSLog(@"[VB Test] enableGreenVB : ret %@.", @(error));
}

- (void)onUseVBButtonClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if (greenSwitch.on) {
        UIView *preview = ms.previewView;
        MobileRTCMeetError error = [ms selectGreenVBPoint:CGPointMake(preview.bounds.size.width/2.0, preview.bounds.size.height/2.0)];
        NSLog(@"[VB Test] selectGreenVBPoint ret = %@", @(error));
    } else {
        if ([ms isSupportSmartVirtualBG]) {
            NSArray *imgList = [ms getBGImageList];
            for (MobileRTCVirtualBGImageInfo *obj in imgList) {
                if (obj.vbType != MobileRTCVBType_None && !obj.isSelect) {
                    MobileRTCMeetError ret = [ms useBGImage:obj];
                    NSLog(@"[VB Test] useBGImage : %@.", @(ret));
                    return;
                }
            }
        }
        NSLog(@"[VB Test] onUseVBButtonClicked : not found any background image");
    }
}

- (void)onNextVBButtonClicked:(id)sender
{
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    NSArray *imgList = [ms getBGImageList];
    self.vbIndex = self.vbIndex % imgList.count;
    MobileRTCVirtualBGImageInfo *imageObj = imgList[self.vbIndex];
    if (imageObj) {
        MobileRTCMeetError ret = [ms useBGImage:imageObj];
        NSLog(@"[VB Test] useBGImage : %@.", @(ret));
        self.vbIndex++;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    CGPoint touchPoint = [[touches  anyObject] locationInView:ms.previewView];
    if (greenSwitch.on) {
        MobileRTCMeetError error = [ms selectGreenVBPoint:touchPoint];
        NSLog(@"[VB Test] selectGreenVBPoint ret = %@", @(error));
    }
}
@end
