//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"

@interface SCMainViewController ()

@end

@implementation SCMainViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initConfig
{
    [self userLog];                             // 开启用户日志
    
    // 监听登录通知，收到通知会触发页面跳转方法
    [NOTIFICATION_CENTER addObserver:self selector:@selector(shouldLogin) name:kUserNeedLoginNotification object:nil];
}

/**
 *  记录用户数据 - 如果有用户登录，获取数据返回给服务器，没有用户登录则不管
 */
- (void)userLog
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
        // 获取用户设备数据，进行远程日志记录
        NSString *os = [UIDevice currentDevice].systemName;
        NSString *osVersion = [UIDevice currentDevice].systemVersion;
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSDictionary *paramters = @{@"user_id": userInfo.userID,
                                    @"os": os,
                                    @"version": appVersion,
                                    @"os_version": osVersion};
        [[SCAPIRequest manager] startUserLogAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            {
                NSLog(@"log_id:%@", responseObject[@"log_id"]);
            }
            else
            {
                NSLog(@"log error:%@", responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log error:%@", error);
        }];
    }
}

/**
 *  收到登录通知，跳转到登录页面
 */
- (void)shouldLogin
{
    @try {
        UINavigationController *loginViewNavigationController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCLoginViewNavigationController"];
        loginViewNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginViewNavigationController animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Go to the SCLoginViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
