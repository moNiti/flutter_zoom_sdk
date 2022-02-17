//
//  FlutterZoomSdkPlugin+CustomizedUIDelegate.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 15/2/2565 BE.
//

#import "FlutterZoomSdkPlugin+CustomizedUIDelegate.h"
#import "OpenGLViewController.h"

@implementation FlutterZoomSdkPlugin (CustomizedUIMeetingDelegate)
- (void)onInitMeetingView
{
    NSLog(@"onInitMeetingView....");
    CustomMeetingViewController *vc = [[CustomMeetingViewController alloc] init];
    self.customMeetingVC = vc;
   
    UIViewController *rootVC  = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootVC addChildViewController:self.customMeetingVC];
    [rootVC.view addSubview:self.customMeetingVC.view];
    [self.customMeetingVC didMoveToParentViewController:rootVC];
    
    self.customMeetingVC.view.frame = rootVC.view.bounds;
}

- (void)onDestroyMeetingView
{
    NSLog(@"onDestroyMeetingView....");
    
    [self.customMeetingVC willMoveToParentViewController:nil];
    [self.customMeetingVC.view removeFromSuperview];
    [self.customMeetingVC removeFromParentViewController];
    self.customMeetingVC = nil;
}

@end
