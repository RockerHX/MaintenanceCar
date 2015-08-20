//
//  SCHomePageViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCHomePageViewController.h"
#import "SCSearchViewController.h"
#import "SCMaintenanceViewController.h"
#import "SCDiscoveryViewController.h"
#import "SCOperationViewController.h"
#import "SCWebViewController.h"
#import <SCLoopScrollView/SCLoopScrollView.h>
#import "SCOperation.h"


static NSString *const HomePageNavControllerID = @"HomePageNavigationController";

static const CGFloat OperationBarHeightOn4_4S  = 250.0f;
static const CGFloat OperationBarHeightOn6     = 340.0f;
static const CGFloat OperationBarHeightOn6Plus = 374.0f;
static const CGFloat ShowShopsBarHeightOn6     = 70.0f;
static const CGFloat ShowShopsBarHeightOn6Plus = 80.0f;
static const CGFloat ServiceButtonCornerRadius = 8.0f;


@implementation SCHomePageViewController {
    NSMutableArray  *_oprationADs;
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
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _shouldShowNaivgationBar = YES;
    [self panGestureSupport:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页]"];
    
    [self panGestureSupport:NO];
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
    [NOTIFICATION_CENTER addObserver:self selector:@selector(loginSuccess:) name:kUserLoginSuccessNotification object:nil];
    
    @weakify(self)
    [RACObserve([SCUserInfo share], loginState) subscribeNext:^(NSNumber *loginState) {
        @strongify(self)
        [self refreshOperationADs];
    }];
}

- (void)viewConfig {
    [self addTopBarShadowLayer];
    // 三个服务按钮圆角处理
    _maintenanceButton.layer.cornerRadius = ServiceButtonCornerRadius;
    _washButton.layer.cornerRadius        = ServiceButtonCornerRadius;
    _repairButton.layer.cornerRadius      = ServiceButtonCornerRadius;
    
    // 根据不同的屏幕尺寸调整首页布局
    switch ([SCVersion currentModel]) {
        case SCDeviceModelTypeIphone4_4S: {
            _operationBarHeight.constant = OperationBarHeightOn4_4S;
            break;
        }
        case SCDeviceModelTypeIphone6: {
            _operationBarHeight.constant = OperationBarHeightOn6;
            _showShopsBarHeight.constant = ShowShopsBarHeightOn6;
            break;
        }
        case SCDeviceModelTypeIphone6Plus: {
            _operationBarHeight.constant = OperationBarHeightOn6Plus;
            _showShopsBarHeight.constant = ShowShopsBarHeightOn6Plus;
            break;
        }
        default: {
            break;
        }
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

- (IBAction)searchButtonPressed {
    _shouldShowNaivgationBar = NO;
    UINavigationController *searchNavigationViewController = [SCSearchViewController navigationInstance];
    searchNavigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchNavigationViewController animated:YES completion:nil];
}

- (IBAction)serviceButtonPressed:(UIButton *)button {
    [self pushToSubViewControllerWithType:button.tag];
}

#pragma mark - Private Methods
/**
 *  添加顶部阴影方法
 */
- (void)addTopBarShadowLayer {
    if (!_topBarShadowLayer) {
        _topBarShadowLayer = [CAGradientLayer layer];
        _topBarShadowLayer.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 69.0f);
        [_topBarShadowLayer setStartPoint:CGPointMake(0.5f, 0.0f)];
        [_topBarShadowLayer setEndPoint:CGPointMake(0.5f, 1.0f)];
        _topBarShadowLayer.colors = @[(id)[UIColor colorWithWhite:0.1f alpha:0.5f].CGColor,
                                      (id)[UIColor clearColor].CGColor];
    }
    [self.view.layer addSublayer:_topBarShadowLayer];
    [self.view.layer insertSublayer:_menuButton.layer above:_topBarShadowLayer];
    [self.view.layer insertSublayer:_searchButton.layer above:_topBarShadowLayer];
}

/**
 *  运营位数据请求方法
 */
- (void)startOperationADsReuqet {
    WEAK_SELF(weakSelf);
    [[SCAppApiRequest manager] startGetOperatADAPIRequestWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCApiRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode = [responseObject[@"status_code"] integerValue];
            if (SCAppApiRequestErrorCodeNoError == statusCode) {
                [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCOperation *operation = [SCOperation objectWithKeyValues:obj];
                    [_oprationADs addObject:operation];
                }];
            }
        }
        [weakSelf refreshOperationADs];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf refreshOperationADs];
    }];
}

/**
 *  刷新运营位
 */
- (void)refreshOperationADs {
    NSMutableArray *images = [@[] mutableCopy];
    if (_oprationADs.count) {
        for (SCOperation *operation in _oprationADs) {
            if (!(operation.needLogin && [SCUserInfo share].loginState)) {
                [images addObject:operation.pictureURL];
            }
        }
    }
    
    _operationView.defaultImage = [UIImage imageNamed:@"MerchantImageDefault"];
    _operationView.images = images;
    [_operationView show:^(NSInteger index) {
        if (_oprationADs.count) {
            SCOperation *operation = _oprationADs[index];
            if (operation.needLogin && (![SCUserInfo share].loginState)) {
                if (_delegate && [_delegate respondsToSelector:@selector(operationPostionNeedLoginWithParameter:)]) {
                    [_delegate operationPostionNeedLoginWithParameter:operation.gift];
                }
            } else {
                [self pushToOperationViewControllerWith:operation];
            }
        }
    } finished:nil];
}

/**
 *  跳转到运营位商家列表
 *
 *  @param operation 运营数据
 */
- (void)pushToOperationViewControllerWith:(SCOperation *)operation {
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

/**
 *  跳转到对应的服务列表
 *
 *  @param type 点击服务按钮类型
 */
- (void)pushToSubViewControllerWithType:(SCHomePageServiceButtonType)type {
    switch (type) {
        case SCHomePageServiceButtonTypeMaintenance: {
            SCUserInfo *userInfo = [SCUserInfo share];
            if (userInfo.loginState) {
                [self.navigationController pushViewController:[SCMaintenanceViewController instance] animated:YES];
            } else {
                [self showShoulLoginAlert];
            }
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

- (void)panGestureSupport:(BOOL)support {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSupportPanGesture:)]) {
        [_delegate shouldSupportPanGesture:support];
    }
}

- (void)loginSuccess:(NSNotification *)notification {
    NSString *gift = notification.object;
    NSString *adImageURL = nil;
    if (gift) {
        for (SCOperation *operation in _oprationADs) {
            if ([operation.gift isEqualToString:gift]) {
                adImageURL = operation.giftImageULR;
                break;
            }
        }
    }
    if (adImageURL) {
        [SCADView showWithDelegate:self imageURL:adImageURL];
    }
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 用户选择是否登录
    if (buttonIndex == alertView.cancelButtonIndex) return;
    [self checkShouldLogin];
}

#pragma mark - SCADView Delegate
- (void)imageLoadCompleted:(SCADView *)adView {
    [adView show];
}

- (void)shouldEnter {
    [self pushToSubViewControllerWithType:SCHomePageServiceButtonTypeShowShops];
}

@end
