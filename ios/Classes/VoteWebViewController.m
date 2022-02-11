//
//  VoteWebViewController.m
//  flutter_zoom_sdk
//
//  Created by Niti Jirakarnwuttikrai on 11/2/2565 BE.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WKWebViewConfiguration.h>
#import "VoteWebViewController.h"

@implementation VoteWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat safeTop = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
           safeTop = window.safeAreaInsets.top;
    }
    CGRect bound= [UIScreen mainScreen].bounds;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    WKWebViewConfiguration *config =  [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, safeTop + 70, bound.size.width, bound.size.height) configuration:config];
       
    
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar.frame = CGRectMake(0, safeTop, bound.size.width, 70);
    [navBar setBackgroundColor:[UIColor whiteColor]];
    [navBar setBarStyle:UIBarStyleBlack];
    navBar.barTintColor = [UIColor whiteColor];
    [navBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"ลงคะแนนเสียง"];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left_normal.png"]  style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    
    
    navItem.leftBarButtonItem = backButton;
    [navBar setItems:@[navItem]];
 

    [self.view addSubview:webView];
    [self.view addSubview:navBar];
    
    NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [webView loadRequest:req];
}

- (void)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

