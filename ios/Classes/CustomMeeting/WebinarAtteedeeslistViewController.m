//
//  WebinarAtteedeeslistViewController.m
//  MobileRTCSample
//
//  Created by Zoom Video Communications on 2020/12/10.
//  Copyright © 2020 Zoom Video Communications, Inc. All rights reserved.
//
#import <MobileRTC/MobileRTC.h>
#import "WebinarAtteedeeslistViewController.h"
#import "Sample-Prefix.h"

@interface WebinarAtteedeeslistViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)   UITableView             *tableView;
@property (nonatomic, strong)   NSArray                 *dataSource;
@end

@implementation WebinarAtteedeeslistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Webinar Atteedees list";
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone:)];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    [self.navigationItem.leftBarButtonItem setTintColor:RGBCOLOR(0x2D, 0x8C, 0xFF)];
    
    self.dataSource = [[[MobileRTC sharedRTC] getMeetingService] getWebinarAttendeeList];
    [self initTableView];
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)initTableView
{
    float h;
    if (IPHONE_X) {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - SAFE_ZOOM_INSETS;
    } else {
        h = SCREEN_HEIGHT-self.navigationController.navigationBar.frame.size.height - 20;
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, h) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero ];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedRowHeight = 0 ;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSInteger userID = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    MobileRTCMeetingWebinarAttendeeInfo * userInfo = [[[MobileRTC sharedRTC] getMeetingService] attendeeInfoByID:userID];
    cell.textLabel.text = userInfo.userName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger userID = [[self.dataSource objectAtIndex:indexPath.row] integerValue];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    MobileRTCMeetingService *ms = [[MobileRTC sharedRTC] getMeetingService];
    if ([ms hasPromptAndDePromptPrivilige]) {
           
            [alertController addAction:[UIAlertAction actionWithTitle:@"Prompt the attendee to panelist"
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    [ms promptAttendee2Panelist:userID];
                                                                    self.dataSource = [ms getWebinarAttendeeList];
                                                                    [self.tableView reloadData];
                                                                }]];
    }
    
    NSString *allowTalkString = [ms isAllowAttendeeTalk:userID] ? @"Disable talking" : @"Allow to talk";
    [alertController addAction:[UIAlertAction actionWithTitle:allowTalkString
                                                                style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    [ms allowAttenddeTalk:userID allow:![ms isAllowAttendeeTalk:userID]];
                                                                }]];
    
    if ([ms isMeetingHost] || [ms isMeetingCoHost]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Remove webinar attendee"
                                                                    style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [ms removeUser:userID];
                                                                    }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Send a private chat message"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        MobileRTCSendChatError error = [ms sendChatToUser:userID WithContent:@"This is a private chat message"];
                                                        NSLog(@"SendChat:sendChatToUser ---> %@", @(error));
                                                    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)                                                                                 style:UIAlertActionStyleCancel
                          handler:^(UIAlertAction *action) {
    }]];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = cell;
        popover.sourceRect = cell.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
