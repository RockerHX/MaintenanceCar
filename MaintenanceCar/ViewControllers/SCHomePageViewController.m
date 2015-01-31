//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <AFNetworking/UIButton+AFNetworking.h>
#import "MicroCommon.h"
#import "SCHomePageDetailView.h"
#import "SCUserInfo.h"
#import "SCAPIRequest.h"
#import "SCAllDictionary.h"
#import "SCWebViewController.h"

@interface SCHomePageViewController () <UIAlertViewDelegate>

@end

@implementation SCHomePageViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页]"];
    
    [_detailView refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)maintenanceButtonPressed:(UIButton *)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        @try {
            UIViewController *maintenanceViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"MaintenanceViewController"];
            [self.navigationController pushViewController:maintenanceViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCHomePageViewController Go to the SCMaintenanceViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
        [self showShoulLoginAlert];
}

- (IBAction)SpecialButtonPressed:(UIButton *)sender
{
    SCSpecial *spcial = [SCAllDictionary share].special;
    if (spcial.html)
    {
        @try {
            SCWebViewController *webViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCWebViewController"];
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCHomePageViewController Go to the SCWebViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
    {
        
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
}

- (void)viewConfig
{
    [self startSpecialRequest];
}

// 自定义数据请求方法(用于首页第四个按钮，预约以及筛选条件)，无参数
- (void)startSpecialRequest
{
    __weak typeof(self)weakSelf = self;
    [[SCAPIRequest manager] startHomePageSpecialAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            SCSpecial *special = [[SCSpecial alloc] initWithDictionary:responseObject error:nil];
            
            [[SCAllDictionary share] replaceSpecialDataWith:special];
            [weakSelf displaySpecialButtonWithData:special];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)displaySpecialButtonWithData:(SCSpecial *)special
{
    _specialLabel.textColor = [UIColor blackColor];
    _specialLabel.text      = special.text;
    _specialButton.enabled  = YES;
    [_specialButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:special.pic_url] placeholderImage:[_specialButton backgroundImageForState:UIControlStateNormal]];
}

/**
 *  提示用户登录的警告框
 */
- (void)showShoulLoginAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登录"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登录", nil];
    [alertView show];
}

/**
 *  检查用户是否需要登录，需要则跳转到登录页面
 */
- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
    {
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

@end
