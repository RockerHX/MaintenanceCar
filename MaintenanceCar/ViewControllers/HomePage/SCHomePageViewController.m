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
#import <SCLoopScrollView/SCLoopScrollView.h>
#import "SCOperation.h"

static NSString *const HomePageNavControllerID = @"HomePageNavigationController";

static const CGFloat OperationBarHeightOn4S    = 250.0f;
static const CGFloat OperationBarHeightOn6     = 340.0f;
static const CGFloat OperationBarHeightOn6Plus = 374.0f;
static const CGFloat ShowShopsBarHeightOn6     = 70.0f;
static const CGFloat ShowShopsBarHeightOn6Plus = 80.0f;
static const CGFloat ServiceButtonCornerRadius = 8.0f;

@implementation SCHomePageViewController {
    NSMutableArray *_oprationADs;
    CAGradientLayer *_topBarShadowLayer;
}

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
    
    if (!_shouldShowNaivgationBar) return;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页]"];
    
    if (!_shouldShowNaivgationBar) return;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    _shouldShowNaivgationBar = YES;
    _oprationADs = @[].mutableCopy;
    
    [self startOperationADsReuqet];
}

- (void)viewConfig {
    [self addTopBarShadowLayer];
    // 三个服务按钮圆角处理
    _maintenanceButton.layer.cornerRadius = ServiceButtonCornerRadius;
    _washButton.layer.cornerRadius        = ServiceButtonCornerRadius;
    _repairButton.layer.cornerRadius      = ServiceButtonCornerRadius;
    
    // 根据不同的屏幕尺寸调整首页布局
    if (IS_IPHONE_6Plus) {
        _operationBarHeight.constant = OperationBarHeightOn6Plus;
        _showShopsBarHeight.constant = ShowShopsBarHeightOn6Plus;
    } else if (IS_IPHONE_6) {
        _operationBarHeight.constant = OperationBarHeightOn6;
        _showShopsBarHeight.constant = ShowShopsBarHeightOn6;
    } else if (IS_IPHONE_4) {
        _operationBarHeight.constant = OperationBarHeightOn4S;
    }
    _centerButtonWidth.constant = (SCREEN_WIDTH + ServiceButtonCornerRadius*2 - 20.0f)/3;
    [self updateViewConstraints];
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowMenu)]) {
        [_delegate shouldShowMenu];
    }
}

- (IBAction)serviceButtonPressed:(UIButton *)button {
    [self popToSubViewControllerWithType:button.tag];
}

#pragma mark - Private Methods
- (void)jumpToSpecialViewControllerWith:(SCOperation *)operation isOperate:(BOOL)isOperate {
    if (operation.html) {
        SCWebViewController *webViewController = [SCWebViewController instance];
        webViewController.title   = operation.text;
        webViewController.loadURL = operation.url;
        [self.navigationController pushViewController:webViewController animated:YES];
    } else {
        SCOperationViewController *operationViewController = [SCOperationViewController instance];
        operationViewController.title = operation.text;
        [operationViewController setRequestParameter:operation.parameter value:operation.value];
        [self.navigationController pushViewController:operationViewController animated:YES];
    }
}

- (void)addTopBarShadowLayer {
    if (!_topBarShadowLayer) {
        _topBarShadowLayer = [CAGradientLayer layer];
        _topBarShadowLayer.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 20.0f);
        [_topBarShadowLayer setStartPoint:CGPointMake(0.5f, 0.0f)];
        [_topBarShadowLayer setEndPoint:CGPointMake(0.5f, 1.0f)];
        _topBarShadowLayer.colors = @[(id)[UIColor colorWithWhite:0.1f alpha:0.5f].CGColor,
                                      (id)[UIColor clearColor].CGColor];
    }
    [self.view.layer addSublayer:_topBarShadowLayer];
}

- (void)startOperationADsReuqet
{
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startGetOperatADAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode = [responseObject[@"status_code"] integerValue];
            if (SCAPIRequestErrorCodeNoError == statusCode) {
                [responseObject[@"data"][@"ad"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCOperation *operation = [SCOperation objectWithKeyValues:obj];
                    [_oprationADs addObject:operation];
                }];
            }
        }
        [weakSelf refreshOperationAD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf refreshOperationAD];
    }];
}

- (void)refreshOperationAD
{
    NSMutableArray *images = [@[] mutableCopy];
    if (_oprationADs.count) {
        for (SCOperation *operation in _oprationADs) {
            [images addObject:operation.pictureURL];
        }
    }
    
    _operationView.defaultImage = [UIImage imageNamed:@"MerchantImageDefault"];
    _operationView.images = images;
    [_operationView show:^(NSInteger index) {
        if (_oprationADs.count) {
            [self jumpToSpecialViewControllerWith:_oprationADs[index] isOperate:YES];
        }
    } finished:nil];
}

/**
 *  跳转到对应的服务列表
 *
 *  @param type 点击服务按钮类型
 */
- (void)popToSubViewControllerWithType:(SCHomePageServiceButtonType)type {
    switch (type) {
        case SCHomePageServiceButtonTypeMaintenance: {
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

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 用户选择是否登录
    if (buttonIndex == alertView.cancelButtonIndex) return;
    [self checkShouldLogin];
}

@end
