//
//  SCViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 NiceHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"

@interface UIViewController (SCViewController) <UIAlertViewDelegate>

/**
 *  提示用户登录的警告框
 */
- (void)showShoulLoginAlert;

/**
 *  检查用户是否需要登录，需要则跳转到登录页面
 */
- (void)checkShouldLogin;

@end


@interface UITableView (SCTableView)

- (void)reLayoutHeaderView;

@end
