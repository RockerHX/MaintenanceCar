//
//  SCWebViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/25.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCWebViewController.h"

@interface SCWebViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@end

@implementation SCWebViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"[%@]", self.title]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithFormat:@"[%@]", self.title]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadWebView];
}

#pragma mark - Private Methods
- (void)initConfig
{
}

- (void)loadWebView
{
    [MBProgressHUD showHUDAddedTo:_webView animated:YES];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadURL]]];
}

- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:_webView animated:YES];
}

#pragma mark - Web View Delegate Methods
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideHUD];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载出错"
                                                    message:@"您是否要重新加载"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        [self loadWebView];
    }
}

@end
