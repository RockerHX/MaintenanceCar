//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import "SCLoginViewController.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import "SCHomePageViewController.h"
#import "SCOrdersViewController.h"
#import "SCCollectionsViewController.h"
#import "SCGroupTicketsViewController.h"
#import "SCCouponsViewController.h"
#import "SCSettingViewController.h"

static NSString *MainNavControllerID = @"MainNavigationController";

@interface SCMainViewController () <SCHomePageViewControllerDelegate, SCOrdersViewControllerDelegate, SCCollectionsViewControllerDelegate, SCGroupTicketsViewControllerDelegate, SCCouponsViewControllerDelegate, SCSettingViewControllerDelegate>
@end

@implementation SCMainViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    return [SCStoryBoardManager navigaitonControllerWithIdentifier:MainNavControllerID
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
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)viewConfig {
    // 添加首页视图
    [self showViewController:[self configHomePage]];
}

#pragma mark - Gesture Recognizer
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController panGestureRecognized:sender];
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
    @try {
        // 添加子视图
        [self addChildViewController:viewController];
        [self.view addSubview:viewController.view];
    }
    @catch (NSException *exception) {
        NSLog(@"Main View Controller Add Sub View Controller Error:%@", exception.reason);
    }
    @finally {
    }
}

- (UINavigationController *)configHomePage {
    UINavigationController *navController = [SCHomePageViewController navigationInstance];
    SCHomePageViewController *viewController = (SCHomePageViewController *)navController.topViewController;
    viewController.delegate = self;
    return navController;
}

#pragma mark - SCUserCenterMenuViewController Delegate
- (void)shouldShowViewControllerOnRow:(SCUserCenterMenuRow)row {
    UINavigationController *navController = nil;
    if (row == SCUserCenterMenuRowHomePage) {
        navController = [self configHomePage];
        [self showViewController:navController];
    } else if (row == SCUserCenterMenuRowSetting) {
        navController = [SCSettingViewController navigationInstance];
        SCSettingViewController *viewController = (SCSettingViewController *)navController.topViewController;
        viewController.delegate = self;
        [self showViewController:navController];
    } else {
        // 检查用户是否登录，在进行相应页面跳转
        if ([SCUserInfo share].loginState) {
            switch (row) {
                case SCUserCenterMenuRowOrder: {
                    navController = [SCOrdersViewController navigationInstance];
                    SCOrdersViewController *viewController = (SCOrdersViewController *)navController.topViewController;
                    viewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowCollection: {
                    navController = [SCCollectionsViewController navigationInstance];
                    SCCollectionsViewController *viewController = (SCCollectionsViewController *)navController.topViewController;
                    viewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowGroupTicket: {
                    navController = [SCGroupTicketsViewController navigationInstance];
                    SCGroupTicketsViewController *viewController = (SCGroupTicketsViewController *)navController.topViewController;
                    viewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowCoupon: {
                    navController = [SCCouponsViewController navigationInstance];
                    SCCouponsViewController *viewController = (SCCouponsViewController *)navController.topViewController;
                    viewController.delegate = self;
                    break;
                }
                default:
                    break;
            }
            [self showViewController:navController];
        } else {
            [self showShoulLoginAlert];
        }
    }
    [self.frostedViewController hideMenuViewController];
}

#pragma mark - Delegate
- (void)shouldShowMenu {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

@end
