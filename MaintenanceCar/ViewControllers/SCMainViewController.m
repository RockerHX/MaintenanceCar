//
//  SCMainViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMainViewController.h"
#import <REFrostedViewController/REFrostedViewController.h>
#import "SCGuideViewController.h"
#import "SCLoginViewController.h"
#import "SCHomePageViewController.h"
#import "SCOrdersViewController.h"
#import "SCCollectionsViewController.h"
#import "SCGroupTicketsViewController.h"
#import "SCCouponsViewController.h"
#import "SCSettingViewController.h"
#import "SCChangeCarDataViewController.h"


static NSString *const kGuideKey = @"kGuideKey";

static NSString *const MainNavControllerID = @"MainNavigationController";


@interface SCMainViewController () <SCGuideViewControllerDelegate, SCHomePageViewControllerDelegate, SCOrdersViewControllerDelegate, SCCollectionsViewControllerDelegate, SCGroupTicketsViewControllerDelegate, SCCouponsViewControllerDelegate, SCSettingViewControllerDelegate, SCChangeCarDataViewControllerDelegate>
@end

@implementation SCMainViewController {
    BOOL _canSupportPanGesture;
    UIView *_preView;
}

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
    _canSupportPanGesture = YES;
    // 开启用户日志
    [self userLog];
    
    // 监听登录通知，收到通知会触发页面跳转方法
    [NOTIFICATION_CENTER addObserver:self selector:@selector(shouldLogin) name:kUserNeedLoginNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(shouludShowGroupTicketReservation) name:kShowTicketReservationNotification object:nil];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)viewConfig {
    // 第一次启动打开引导页
    [self showGuide];
}

#pragma mark - Gesture Recognizer
- (void)panGestureRecognized:(UIPanGestureRecognizer *)pan {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    if (_canSupportPanGesture) {
        // Present the view controller
        [self.frostedViewController panGestureRecognized:pan];
    }
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
        [[SCAppApiRequest manager] startUserLogAPIRequestWithParameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCApiRequestStatusCodePOSTSuccess) {
                NSLog(@"log_id:%@", responseObject[@"log_id"]);
            } else {
                NSLog(@"log error:%@", responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"log error:%@", error);
        }];
        
        if ([userInfo needRefreshToken]) {
            [[SCAppApiRequest manager] startRefreshTokenAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (operation.response.statusCode == SCApiRequestStatusCodePOSTSuccess) {
                    NSInteger errorCode = [responseObject[@"status_code"] integerValue];
                    if (!errorCode) {
                        [userInfo refreshTokenDate];
                    }
                }
            } failure:nil];
        }
    }
}

/**
 *  收到登录通知，跳转到登录页面
 */
- (void)shouldLogin {
    [self shouldLoginWithParameter:nil];
}

/**
 *  执行登录页跳转
 *
 *  @param parameter 登录参数
 */
- (void)shouldLoginWithParameter:(NSString *)parameter {
    WEAK_SELF(weakSelf);
    [self setHomePageNavigationBarWillHidden:NO];
    UINavigationController *loginViewNavigationController = [SCLoginViewController navigationInstance];
    SCLoginViewController *loginViewController = (SCLoginViewController *)loginViewNavigationController.topViewController;
    loginViewController.parameter = parameter;
    loginViewNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginViewNavigationController animated:YES completion:^{
        [weakSelf hideMenu];
    }];
}

/**
 *  展示引导页
 */
- (void)showGuide {
    if ([self firstLaunch]) {
        SCGuideViewController *guideViewController = [SCGuideViewController instance];
        guideViewController.delegate = self;
        [self addChildViewController:guideViewController];
        [self.view addSubview:guideViewController.view];
    } else {
        // 添加首页视图
        [self showViewController:[self configHomePage]];
    }
}

/**
 *  判断是否是第一次启动
 */
- (BOOL)firstLaunch {
    return ![[USER_DEFAULT objectForKey:kGuideKey] boolValue];
}

/**
 *  添加显示视图控制器
 *
 *  @param viewController 需要显示的视图控制器
 */
- (void)showViewController:(UIViewController *)viewController {
    [self setHomePageNavigationBarWillHidden:NO];
    @try {
        _canSupportPanGesture = YES;
        // 添加子视图
        UIView *fromView = self.view.subviews[self.view.subviews.count - 1];
        UIView *toView = viewController.view;
        WEAK_SELF(weakSelf);
        [UIView transitionFromView:fromView toView:toView duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
            _preView = fromView;
            [weakSelf addChildViewController:viewController];
            [weakSelf.view addSubview:viewController.view];
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Main View Controller Add Sub View Controller Error:%@", exception.reason);
    }
    @finally {
    }
}

/**
 *  移除显示视图控制器
 *
 *  @param viewController 移除显示的视图控制器
 */
- (void)removeViewController:(UIViewController *)viewController animation:(BOOL)animation {
    @try {
        // 移除子视图
        WEAK_SELF(weakSelf);
        UIView *fromView = viewController.view;
        UIView *toView = _preView;
        if (animation) {
            [UIView transitionFromView:fromView toView:toView duration:1.0f options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
                [weakSelf removeViewController:viewController];
            }];
        } else {
            [self removeViewController:viewController];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Main View Controller Remove Sub View Controller Error:%@", exception.reason);
    }
    @finally {
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
}

/**
 *  配置首页控制器(负责代理设置)
 *
 *  @return 首页的导航控制器
 */
- (UINavigationController *)configHomePage {
    UINavigationController *navController = [SCHomePageViewController navigationInstance];
    SCHomePageViewController *viewController = (SCHomePageViewController *)navController.topViewController;
    viewController.delegate = self;
    return navController;
}

/**
 *  关闭侧滑导航栏
 */
- (void)hideMenu {
    [self.frostedViewController hideMenuViewController];
}

/**
 *  设置首页在跳转之后是否需要显示导航栏
 */
- (void)setHomePageNavigationBarWillHidden:(BOOL)hidden {
    UINavigationController *navController = [SCHomePageViewController navigationInstance];
    for (UIViewController *viewController in navController.viewControllers) {
        if ([viewController isKindOfClass:[SCHomePageViewController class]]) {
            ((SCHomePageViewController *)viewController).shouldShowNaivgationBar = hidden;
            break;
        }
    }
}

- (void)shouludShowGroupTicketReservation {
    [self shouldShowViewControllerOnRow:SCUserCenterMenuRowOrder];
}

#pragma mark - SCGuideViewController Delegate
- (void)guideFinished {
    [USER_DEFAULT setObject:@(YES) forKey:kGuideKey];
    [USER_DEFAULT synchronize];
    
    [self shouldShowViewControllerOnRow:SCUserCenterMenuRowHomePage];
}

#pragma mark - SCUserCenterMenuViewController Delegate
// 出现加车操作的适合，处理首页导航栏是否显示问题，避免出现页面跳转交互问题
- (void)willShowAddCarSence {
    [self setHomePageNavigationBarWillHidden:NO];
}

// 处理个人中心相关选项点击跳转
- (void)shouldShowViewControllerOnRow:(SCUserCenterMenuRow)row {
    UINavigationController *navController = nil;
    // 首页和设置页面不需要检查登陆，再次单独处理页面跳转
    if (row == SCUserCenterMenuRowHomePage) {
        navController = [self configHomePage];
        [self showViewController:navController];
    } else if (row == SCUserCenterMenuRowSetting) {
        navController = [SCSettingViewController navigationInstance];
        SCSettingViewController *settingViewController = (SCSettingViewController *)navController.topViewController;
        settingViewController.delegate = self;
        [self showViewController:navController];
    } else {
        // 检查用户是否登录，再进行相应页面跳转
        if ([SCUserInfo share].loginState) {
            switch (row) {
                case SCUserCenterMenuRowOrder: {
                    navController = [SCOrdersViewController navigationInstance];
                    SCOrdersViewController *ordersViewController = (SCOrdersViewController *)navController.topViewController;
                    ordersViewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowCollection: {
                    navController = [SCCollectionsViewController navigationInstance];
                    SCCollectionsViewController *collectionsViewController = (SCCollectionsViewController *)navController.topViewController;
                    collectionsViewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowGroupTicket: {
                    navController = [SCGroupTicketsViewController navigationInstance];
                    SCGroupTicketsViewController *groupTicketsViewController = (SCGroupTicketsViewController *)navController.topViewController;
                    groupTicketsViewController.delegate = self;
                    break;
                }
                case SCUserCenterMenuRowCoupon: {
                    navController = [SCCouponsViewController navigationInstance];
                    SCCouponsViewController *couponsViewController = (SCCouponsViewController *)navController.topViewController;
                    couponsViewController.delegate = self;
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
}

- (void)shouldShowCarDataViewController:(SCUserCar *)userCar {
    UINavigationController *navController = [SCChangeCarDataViewController navigationInstance];
    SCChangeCarDataViewController *changeCarDataViewController = (SCChangeCarDataViewController *)navController.topViewController;
    changeCarDataViewController.delegate = self;
    changeCarDataViewController.car = userCar;
    [self showViewController:navController];
}

#pragma mark - Sub Content View Controller Delegate
- (void)shouldShowMenu {
    // Dismiss keyboard (optional)
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

- (void)shouldSupportPanGesture:(BOOL)support {
    _canSupportPanGesture = support;
}

#pragma mark - SCHomePageViewController Delegate
- (void)operationPostionNeedLoginWithParameter:(NSString *)parameter {
    [self shouldLoginWithParameter:parameter];
}

#pragma mark - SCChangeCarDataViewController Delegate
- (void)userCarDataSaveSuccess:(UIViewController *)viewController {
    [self removeViewController:viewController animation:YES];
}

- (void)userCarDataDeleteSuccess:(UIViewController *)viewController {
    [self removeViewController:viewController animation:YES];
}

@end
