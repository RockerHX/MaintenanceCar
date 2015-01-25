//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageViewController.h"
#import <UMengAnalytics/MobClick.h>
#import "MicroCommon.h"
#import "SCHomePageDetailView.h"
#import "SCUserInfo.h"
#import "SCAPIRequest.h"
#import "SCWeather.h"
#import "SCWashViewController.h"

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

- (IBAction)repairButtonPressed:(UIButton *)sender
{
}

#pragma mark - Private Methods
- (void)startWeatherReuqest
{
    [[SCAPIRequest manager] startWearthAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSError *error = nil;
        SCWeather *weather = [[SCWeather alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"title:%@", weather.title);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

/**
 *  提示用户登陆的警告框
 */
- (void)showShoulLoginAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登陆"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登陆", nil];
    [alertView show];
}

/**
 *  检查用户是否需要登陆，需要则跳转到登陆页面
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
    // 用户选择是否登陆
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

@end
