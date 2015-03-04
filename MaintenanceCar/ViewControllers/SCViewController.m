//
//  SCViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 NiceHome. All rights reserved.
//

#import "SCViewController.h"

@implementation UIViewController (SCViewController)

#pragma mark - Public Methods
- (void)showShoulLoginAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登录"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登录", nil];
    [alertView show];
}

- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
}

@end
