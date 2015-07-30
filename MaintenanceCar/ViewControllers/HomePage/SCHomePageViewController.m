//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageViewController.h"
#import <AFNetworking/UIButton+AFNetworking.h>
#import "SCHomePageDetailView.h"
#import "SCAllDictionary.h"
#import "SCOperationViewController.h"
#import "SCMaintenanceViewController.h"
#import "SCADView.h"
#import "SCWebViewController.h"
#import "SCChangeCarDataViewController.h"
#import "SCAddCarViewController.h"

static NSString *HomePageNavControllerID = @"HomePageNavigationController";

static CGFloat OperationBarHeightOn4S    = 250.0f;
static CGFloat OperationBarHeightOn6     = 340.0f;
static CGFloat OperationBarHeightOn6Plus = 374.0f;
static CGFloat ShowShopsBarHeightOn6     = 70.0f;
static CGFloat ShowShopsBarHeightOn6Plus = 80.0f;

@interface SCHomePageViewController () <SCADViewDelegate, SCHomePageDetailViewDelegate>
@end

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
    [self startSpecialRequest];
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
        case SCHomePageServiceButtonTypeRepair: {
            SCOperationViewController *repairViewController = [SCOperationViewController instance];
            repairViewController.title = @"维修";
            [repairViewController setRequestParameter:@"product_tag" value:@"维修"];
            [self.navigationController pushViewController:repairViewController animated:YES];
            break;
        }
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
        case SCHomePageServiceButtonTypeOperation: {
            SCSpecial *special = [SCAllDictionary share].special;
            SCADView *adView = [[SCADView alloc] initWithDelegate:self imageURL:special.post_pic];
            [adView show];
            break;
        }
    }
}

#pragma mark - Private Methods
// 自定义数据请求方法(用于首页第四个按钮，预约以及筛选条件)，无参数
- (void)startSpecialRequest {
    [[SCAPIRequest manager] startHomePageSpecialAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess) {
            SCSpecial *special = [[SCSpecial alloc] initWithDictionary:responseObject error:nil];
        }
    } failure:nil];
}

- (void)jumpToSpecialViewControllerWith:(SCSpecial *)special isOperate:(BOOL)isOperate {
    if (special.html) {
        SCWebViewController *webViewController = [SCWebViewController instance];
        webViewController.title   = special.text;
        webViewController.loadURL = special.url;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else {
        SCOperationViewController *operationViewController = [SCOperationViewController instance];
        operationViewController.title = special.text;
        [operationViewController setRequestParameter:special.parameter value:special.value];
        [self.navigationController pushViewController:operationViewController animated:YES];
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self checkShouldLogin];
    }
}

#pragma mark - SCADViewDelegate Methods
- (void)shouldEnter {
    [self jumpToSpecialViewControllerWith:[SCAllDictionary share].special isOperate:NO];
}

#pragma mark - SCHomePageDetailViewDelegate Methods
- (void)shouldShowOperatAd:(SCSpecial *)special {
    [self jumpToSpecialViewControllerWith:special isOperate:YES];
}

- (void)shouldAddCar {
    UINavigationController *navigationControler = [SCAddCarViewController navigationInstance];
    [self presentViewController:navigationControler animated:YES completion:nil];
}

- (void)shouldChangeCarData:(SCUserCar *)userCar {
    SCChangeCarDataViewController *viewController = [SCChangeCarDataViewController instance];
    viewController.car = userCar;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
