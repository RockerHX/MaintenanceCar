//
//  SCUserViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCUserInfo.h"
#import "SCLoginViewController.h"
#import "SCMyFavoriteTableViewController.h"
#import "SCMyReservationTableViewController.h"
#import "SCAddCarViewController.h"
#import "SCUserInfoView.h"
#import "SCChangeMaintenanceDataViewController.h"

typedef NS_ENUM(NSInteger, SCUserCenterRow) {
    SCUserCenterRowMyOrder = 0,
    SCUserCenterRowMyCollection,
    SCUserCenterRowMyCustomers,
    SCUserCenterRowMyReservation,
};

@interface SCUserViewController () <UIAlertViewDelegate, SCAddCarViewControllerDelegate, SCUserInfoViewDelegate, SCChangeMaintenanceDataViewControllerDelegate>

@end

@implementation SCUserViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[我] - 个人中心"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_userInfoView refresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[我] - 个人中心"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 检查用户是否登录，在进行相应页面跳转
    if ([SCUserInfo share].loginStatus)
    {
        @try {
            switch (indexPath.row)
            {
                case SCUserCenterRowMyOrder:
                {
                    SCMyReservationTableViewController *myReservationTableViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyReservationTableViewController"];
                    [self pushToSubViewControllerWithController:myReservationTableViewController];
                }
                    break;
                case SCUserCenterRowMyCollection:
                {
                    SCMyFavoriteTableViewController *myFavoriteTableViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyFavoriteTableViewController"];
                    [self pushToSubViewControllerWithController:myFavoriteTableViewController];
                }
                    break;
                    
                default:
                    break;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"User Center Push Controller Error:%@", exception.reason);
        }
        @finally {
        }
    }
    else
        [self showShoulLoginAlert];
}

#pragma mark - Button Action Methods

#pragma mark - Private Methods
- (void)viewConfig
{
    _userInfoView.delegate = self;
    
    if (IS_IPHONE_6)
        self.tableView.tableHeaderView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 220.f);
    else if (IS_IPHONE_6Plus)
        self.tableView.tableHeaderView.frame = CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, 240.f);
    [self.tableView.tableHeaderView needsUpdateConstraints];
    [self.tableView.tableHeaderView layoutIfNeeded];
}

/**
 *  Push到一个页面，带动画
 *
 *  @param viewController 需要Push到的页面
 */
- (void)pushToSubViewControllerWithController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

/**
 *  检查用户是否需要登录，需要则跳转到登录页面
 */
- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
    {
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
    }
}

/**
 *  提示用户登录的警告框
 */
- (void)showShoulLoginAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登录"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登录", nil];
    [alertView show];
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

// [添加车辆]按钮被点击，跳转到添加车辆页面
- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        @try {
            UINavigationController *addCarViewNavigationControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAddCarViewNavigationController"];
            SCAddCarViewController *addCarViewController = (SCAddCarViewController *)addCarViewNavigationControler.topViewController;
            addCarViewController.delegate = self;
            [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"SCMyReservationTableViewController Go to the SCAddCarViewNavigationControler exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
    else
        [self showShoulLoginAlert];
}

#pragma mark - SCAddCarViewController Delegate Methods
- (void)addCarSuccessWith:(NSString *)userCarID
{
    // 车辆添加成功的回调方法，车辆添加成功以后需要刷新个人中心，展示出用户最新添加的车辆
    [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
        [_userInfoView refresh];
    }];
}

#pragma mark - SCUserInfoViewDelegate Methods
- (void)shouldLogin
{
    [self checkShouldLogin];
}

- (void)shouldChangeCarData:(SCUserCar *)userCar
{
    @try {
        SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCChangeMaintenanceDataViewController"];
        changeMaintenanceDataViewController.delegate = self;
        changeMaintenanceDataViewController.car = userCar;
        [self.navigationController pushViewController:changeMaintenanceDataViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCHomePageViewController Go to the SCChangeMaintenanceDataViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - SCChangeMaintenanceDataViewControllerDelegate Methods
- (void)dataSaveSuccess
{
    [self addCarSuccessWith:nil];
}

@end
