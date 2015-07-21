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

@interface SCHomePageViewController () <SCADViewDelegate, SCHomePageDetailViewDelegate>
@end

@implementation SCHomePageViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页]"];
    
    [_detailView refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameHomePage];
}

#pragma mark - Class Methods
+ (NSString *)navgationRestorationIdentifier
{
    return @"HomePageNavigationController";
}

#pragma mark - Config Methods
- (void)initConfig
{
    [self startSpecialRequest];
}

- (void)viewConfig
{
    if (IS_IPHONE_6Plus)
        _buttonWidthConstraint.constant = 110.0f;
    else if (IS_IPHONE_6)
        _buttonWidthConstraint.constant = 90.0f;
    else if (IS_IPHONE_5)
        _buttonWidthConstraint.constant = 75.0f;
    else
        _buttonWidthConstraint.constant = 55.0f;
    
    [self.view needsUpdateConstraints];
    [self.view layoutIfNeeded];
}

#pragma mark - Action Methods
- (IBAction)locationItemPressed
{
    [self showAlertWithTitle:@"温馨提示" message:@"您好，修养目前只开通了深圳城市试运营，其他城市暂时还没有开通，感谢您对修养的关注。"];
}

- (void)maintenanceButtonPressed
{
}

- (IBAction)serviceButtonPressed:(UIButton *)button
{
    switch (button.tag)
    {
        case SCHomePageServiceButtonTypeRepair:
        {
            SCOperationViewController *repairViewController = [SCOperationViewController instance];
            repairViewController.title = @"维修";
            [repairViewController setRequestParameter:@"product_tag" value:@"维修"];
            [self.navigationController pushViewController:repairViewController animated:YES];
        }
            break;
        case SCHomePageServiceButtonTypeMaintance:
        {
            SCUserInfo *userInfo = [SCUserInfo share];
            if (userInfo.loginState)
                [self.navigationController pushViewController:[SCMaintenanceViewController instance] animated:YES];
            else
                [self showShoulLoginAlert];
        }
            break;
        case SCHomePageServiceButtonTypeWash:
        {
            SCOperationViewController *washViewController = [SCOperationViewController instance];
            washViewController.title = @"洗车美容";
            [washViewController setRequestParameter:@"product_tag" value:@"洗车,美容"];
            [self.navigationController pushViewController:washViewController animated:YES];
        }
            break;
        case SCHomePageServiceButtonTypeOperation:
        {
            SCSpecial *special = [SCAllDictionary share].special;
            SCADView *adView = [[SCADView alloc] initWithDelegate:self imageURL:special.post_pic];
            [adView show];
        }
            break;
    }
}

#pragma mark - Private Methods
// 自定义数据请求方法(用于首页第四个按钮，预约以及筛选条件)，无参数
- (void)startSpecialRequest
{
    WEAK_SELF(weakSelf);
    [[SCAPIRequest manager] startHomePageSpecialAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            SCSpecial *special = [[SCSpecial alloc] initWithDictionary:responseObject error:nil];
            [[SCAllDictionary share] replaceSpecialDataWith:special];
            [weakSelf displaySpecialButtonWithData:special];
        }
    } failure:nil];
}

- (void)displaySpecialButtonWithData:(SCSpecial *)special
{
    _specialLabel.textColor = [UIColor blackColor];
    _specialLabel.text      = special.text;
    _specialButton.enabled  = YES;
    [_specialButton setBackgroundImageForState:UIControlStateNormal
                                       withURL:[NSURL URLWithString:special.pic_url]
                              placeholderImage:[_specialButton backgroundImageForState:UIControlStateNormal]];
}

- (void)jumpToSpecialViewControllerWith:(SCSpecial *)special isOperate:(BOOL)isOperate
{
    if (special.html)
    {
        SCWebViewController *webViewController = [SCWebViewController instance];
        webViewController.title   = special.text;
        webViewController.loadURL = special.url;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else
    {
        SCOperationViewController *operationViewController = [SCOperationViewController instance];
        operationViewController.title = special.text;
        [operationViewController setRequestParameter:special.parameter value:special.value];
        [self.navigationController pushViewController:operationViewController animated:YES];
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex)
        [self checkShouldLogin];
}

#pragma mark - SCADViewDelegate Methods
- (void)shouldEnter
{
    [self jumpToSpecialViewControllerWith:[SCAllDictionary share].special isOperate:NO];
}

#pragma mark - SCHomePageDetailViewDelegate Methods
- (void)shouldShowOperatAd:(SCSpecial *)special
{
    [self jumpToSpecialViewControllerWith:special isOperate:YES];
}

- (void)shouldAddCar
{
    UINavigationController *navigationControler = [SCAddCarViewController navigationInstance];
    [self presentViewController:navigationControler animated:YES completion:nil];
}

- (void)shouldChangeCarData:(SCUserCar *)userCar
{
    SCChangeCarDataViewController *viewController = [SCChangeCarDataViewController instance];
    viewController.car = userCar;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
