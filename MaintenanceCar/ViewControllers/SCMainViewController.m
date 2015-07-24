//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import "SCLoginViewController.h"
#import "REFrostedViewController.h"
#import "SCHomePageViewController.h"
#import "SCOrdersViewController.h"

static NSString *MainNavigationControllerStoryboardID = @"MainNavigationController";

@implementation SCMainViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    return [SCStoryBoardManager navigaitonControllerWithIdentifier:MainNavigationControllerStoryboardID
                                                    storyBoardName:SCStoryBoardNameMain];
}

+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameMain];
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    // 开启用户日志
    [self userLog];
    
    // 监听登录通知，收到通知会触发页面跳转方法
    [NOTIFICATION_CENTER addObserver:self
                            selector:@selector(shouldLogin)
                                name:kUserNeedLoginNotification
                              object:nil];
}

- (void)viewConfig {
    // 添加首页视图
    [self shouldShowViewControllerOnRow:SCUserCenterMenuRowHomePage];
}

#pragma mark - Action
- (IBAction)showMenu {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

#pragma mark - Private Methods
/**
 *  记录用户数据 - 如果有用户登录，获取数据返回给服务器，没有用户登录则不管
 */
- (void)userLog {
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginState) {
        // 获取用户设备数据，进行远程日志记录
        NSString *os = [UIDevice currentDevice].systemName;
        NSString *osVersion = [UIDevice currentDevice].systemVersion;
        NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        NSDictionary *paramters = @{@"user_id": userInfo.userID,
                                         @"os": os,
                                    @"version": appVersion,
                                 @"os_version": osVersion};
        [[SCAPIRequest manager] startUserLogAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
                NSLog(@"log_id:%@", responseObject[@"log_id"]);
            else
                NSLog(@"log error:%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log error:%@", error);
        }];
        
        if ([userInfo needRefreshToken]) {
            [[SCAPIRequest manager] startRefreshTokenAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess) {
                    NSInteger errorCode = [responseObject[@"status_code"] integerValue];
                    if (!errorCode) [userInfo refreshTokenDate];
                }
            } failure:nil];
        }
    }
}

/**
 *  收到登录通知，跳转到登录页面
 */
- (void)shouldLogin {
    UINavigationController *loginViewNavigationController = [SCLoginViewController navigationInstance];
    loginViewNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginViewNavigationController animated:YES completion:nil];
}

- (void)showViewController:(UIViewController *)viewController {
    // 添加子视图
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    
    //把menu按钮放到最顶层
    [self.view insertSubview:_menuButton atIndex:self.view.subviews.count];
}

#pragma mark - SCUserCenterMenuViewController Delegate
- (void)shouldShowViewControllerOnRow:(SCUserCenterMenuRow)row {
    // 检查用户是否登录，在进行相应页面跳转
    if ([SCUserInfo share].loginState)
    {
        UIViewController *viewController = nil;
        switch (row) {
            case SCUserCenterMenuRowHomePage: {
                viewController = [SCHomePageViewController instance];
                break;
            }
            case SCUserCenterMenuRowOrder: {
                viewController = [SCOrdersViewController navigationInstance];
                break;
            }
            case SCUserCenterMenuRowCollection: {
                
                break;
            }
            case SCUserCenterMenuRowGroupTicket: {
                
                break;
            }
            case SCUserCenterMenuRowCoupon: {
                
                break;
            }
            case SCUserCenterMenuRowSetting: {
                
                break;
            }
        }
        [self showViewController:viewController];
        [self.frostedViewController hideMenuViewController];
    } else {
        [self showShoulLoginAlert];
    }
}

@end
