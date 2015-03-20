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
#import "SCWebViewController.h"
#import "SCServiceMerchantListViewController.h"
#import "SCADView.h"
#import "SCChangeMaintenanceDataViewController.h"

@interface SCHomePageViewController () <SCADViewDelegate, SCHomePageDetailViewDelegate, SCChangeMaintenanceDataViewControllerDelegate>

@end

@implementation SCHomePageViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页]"];
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
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.3f];
    [self initConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Wash"])
    {
        SCServiceMerchantListViewController *washMerchanListViewController = segue.destinationViewController;
        washMerchanListViewController.isWash   = YES;
        washMerchanListViewController.query    = [DefaultQuery stringByAppendingString:@" AND service:'洗'"];
        washMerchanListViewController.title    = @"洗车美容";
    }
    else if ([segue.identifier isEqualToString:@"Repair"])
    {
        SCServiceMerchantListViewController *repairMerchanListViewController = segue.destinationViewController;
        repairMerchanListViewController.query    = [DefaultQuery stringByAppendingString:@" AND service:'修'"];
        repairMerchanListViewController.title    = @"维修";
    }
}

#pragma mark - Action Methods
- (IBAction)locationItemPressed:(UIBarButtonItem *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您好，修养目前只开通了深圳城市试运营，其他城市暂时还没有开通，感谢您对修养的关注。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (IBAction)maintenanceButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
        @try {
            UIViewController *maintenanceViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"MaintenanceViewController"];
            [self.navigationController pushViewController:maintenanceViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCHomePageViewController Go to the SCMaintenanceViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
        [self showShoulLoginAlert];
}

- (IBAction)SpecialButtonPressed:(UIButton *)sender
{
    SCSpecial *special = [SCAllDictionary share].special;
    SCADView *adView = [[SCADView alloc] initWithDelegate:self imageURL:special.post_pic];
    [adView show];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _detailView.delegate = self;
    [NOTIFICATION_CENTER addObserver:_detailView selector:@selector(refresh) name:kUserCarsDataLoadSuccess object:nil];
    
    [_detailView refresh];
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
    
    [_washButton needsUpdateConstraints];
    [_washButton layoutIfNeeded];
    [_washLabel needsUpdateConstraints];
    [_washLabel layoutIfNeeded];
    [_maintenanceButton needsUpdateConstraints];
    [_maintenanceButton layoutIfNeeded];
    [_maintenanceLabel needsUpdateConstraints];
    [_maintenanceLabel layoutIfNeeded];
    [_repairButton needsUpdateConstraints];
    [_repairButton layoutIfNeeded];
    [_repairLabel needsUpdateConstraints];
    [_repairLabel layoutIfNeeded];
    [_specialButton needsUpdateConstraints];
    [_specialButton layoutIfNeeded];
    [_specialLabel needsUpdateConstraints];
    [_specialLabel layoutIfNeeded];
    
    _washButton.hidden = NO;
    _washLabel.hidden = NO;
    _maintenanceButton.hidden = NO;
    _maintenanceLabel.hidden = NO;
    _repairButton.hidden = NO;
    _repairLabel.hidden = NO;
    _specialButton.hidden = NO;
    _specialLabel.hidden = NO;
    
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

// 自定义数据请求方法(用于首页第四个按钮，预约以及筛选条件)，无参数
- (void)startSpecialRequest
{
    __weak typeof(self)weakSelf = self;
    [[SCAPIRequest manager] startHomePageSpecialAPIRequestSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            SCSpecial *special = [[SCSpecial alloc] initWithDictionary:responseObject error:nil];
            
            [[SCAllDictionary share] replaceSpecialDataWith:special];
            [weakSelf displaySpecialButtonWithData:special];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)displaySpecialButtonWithData:(SCSpecial *)special
{
    _specialLabel.textColor = [UIColor blackColor];
    _specialLabel.text      = special.text;
    _specialButton.enabled  = YES;
    [_specialButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:special.pic_url] placeholderImage:[_specialButton backgroundImageForState:UIControlStateNormal]];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

#pragma mark - SCADViewDelegate Methods
- (void)shouldEnter
{
    SCSpecial *special = [SCAllDictionary share].special;
    if (special.html)
    {
        @try {
            SCWebViewController *webViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCWebViewController"];
            webViewController.title = special.text;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCHomePageViewController Go to the SCWebViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
    {
        @try {
            SCServiceMerchantListViewController *specialViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCServiceMerchantListViewController"];
            specialViewController.query    = [DefaultQuery stringByAppendingFormat:@" AND %@", special.query];
            specialViewController.title    = special.text;
            [self.navigationController pushViewController:specialViewController animated:YES];
        }
        @catch (NSException *exception) {
            NSLog(@"SCHomePageViewController Go to the SCServiceMerchantListViewController exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

#pragma mark - SCHomePageDetailViewDelegate Methods
- (void)shouldLogin
{
    [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
}

- (void)shouldAddCar
{
    @try {
        UINavigationController *addCarViewNavigationControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAddCarViewNavigationController"];
        [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyReservationTableViewController Go to the SCAddCarViewNavigationControler exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

- (void)shouldChangeCarData:(SCUserCar *)userCar
{
    @try {
        SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCChangeMaintenanceDataViewController"];
        changeMaintenanceDataViewController.car = userCar;
        [self.navigationController pushViewController:changeMaintenanceDataViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCHomePageViewController Go to the SCChangeMaintenanceDataViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
