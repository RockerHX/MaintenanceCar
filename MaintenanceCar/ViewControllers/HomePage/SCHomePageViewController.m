//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageViewController.h"
#import "SCMaintenanceViewController.h"
#import "SCDiscoveryViewController.h"
#import "SCOperationViewController.h"
#import "SCWebViewController.h"

static NSString *const HomePageNavControllerID = @"HomePageNavigationController";

static const CGFloat OperationBarHeightOn4S    = 250.0f;
static const CGFloat OperationBarHeightOn6     = 340.0f;
static const CGFloat OperationBarHeightOn6Plus = 374.0f;
static const CGFloat ShowShopsBarHeightOn6     = 70.0f;
static const CGFloat ShowShopsBarHeightOn6Plus = 80.0f;

@implementation SCHomePageViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    static UINavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [SCStoryBoardManager navigaitonControllerWithIdentifier:HomePageNavControllerID
                                                                        storyBoardName:SCStoryBoardNameHomePage];
    });
    return navigationController;
}

+ (instancetype)instance {
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameHomePage];;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页]"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页]"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
}

- (void)viewConfig {
    if (IS_IPHONE_6Plus) {
        _operationBarHeight.constant = OperationBarHeightOn6Plus;
        _showShopsBarHeight.constant = ShowShopsBarHeightOn6Plus;
    } else if (IS_IPHONE_6) {
        _operationBarHeight.constant = OperationBarHeightOn6;
        _showShopsBarHeight.constant = ShowShopsBarHeightOn6;
    } else if (IS_IPHONE_4) {
        _operationBarHeight.constant = OperationBarHeightOn4S;
    }
    [self updateViewConstraints];
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowMenu)]) {
        [_delegate shouldShowMenu];
    }
}

- (IBAction)serviceButtonPressed:(UIButton *)button {
    switch (button.tag) {
        case SCHomePageServiceButtonTypeMaintance: {
            SCUserInfo *userInfo = [SCUserInfo share];
            if (userInfo.loginState)
                [self.navigationController pushViewController:[SCMaintenanceViewController instance] animated:YES];
            else
                [self showShoulLoginAlert];
            break;
        }
        case SCHomePageServiceButtonTypeWash: {
            SCOperationViewController *washViewController = [SCOperationViewController instance];
            washViewController.title = @"洗车美容";
            [washViewController setRequestParameter:@"product_tag" value:@"洗车,美容"];
            [self.navigationController pushViewController:washViewController animated:YES];
            break;
        }
        case SCHomePageServiceButtonTypeRepair: {
            SCOperationViewController *repairViewController = [SCOperationViewController instance];
            repairViewController.title = @"维修";
            [repairViewController setRequestParameter:@"product_tag" value:@"维修"];
            [self.navigationController pushViewController:repairViewController animated:YES];
            break;
        }
        case SCHomePageServiceButtonTypeShowShops: {
            SCDiscoveryViewController *discoveryViewController = [SCDiscoveryViewController instance];
            [self.navigationController pushViewController:discoveryViewController animated:YES];
            break;
        }
    }
}

#pragma mark - Private Methods
//- (void)jumpToSpecialViewControllerWith:(SCSpecial *)special isOperate:(BOOL)isOperate {
//    if (special.html) {
//        SCWebViewController *webViewController = [SCWebViewController instance];
//        webViewController.title   = special.text;
//        webViewController.loadURL = special.url;
//        [self.navigationController pushViewController:webViewController animated:YES];
//    } else {
//        SCOperationViewController *operationViewController = [SCOperationViewController instance];
//        operationViewController.title = special.text;
//        [operationViewController setRequestParameter:special.parameter value:special.value];
//        [self.navigationController pushViewController:operationViewController animated:YES];
//    }
//}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self checkShouldLogin];
    }
}

#pragma mark - SCHomePageDetailViewDelegate Methods
//- (void)shouldShowOperatAd:(SCSpecial *)special {
//    [self jumpToSpecialViewControllerWith:special isOperate:YES];
//}

@end
