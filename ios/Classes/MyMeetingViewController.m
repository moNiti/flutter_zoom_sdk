//
//  MyMeetingViewController.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 18/2/2565 BE.
//

#import "MyMeetingViewController.h"
#import <MobileRTC/MobileRTC.h>

@interface MyMeetingViewController ()

@end

@implementation MyMeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.baseView];
    [self.baseView addSubview:self.meetingView];
    
}

- (UIView*)baseView
{
    if (!_baseView)
    {
        _baseView = [[UIView alloc] initWithFrame:self.view.bounds];
        _baseView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _baseView;
}

- (UIView*)meetingView
{
    if (!_meetingView)
    {
        _meetingView = [[[MobileRTC sharedRTC] getMeetingService] meetingView];
        if(_meetingView) {
            NSLog(@"MeetingView =>>>>>>>>>>>>>>>>>>>>>");
        }
        _meetingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _meetingView;
}


@end
