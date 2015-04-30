//
//  SCUserViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserViewController.h"
#import "SCLoginViewController.h"
#import "SCMyFavoriteTableViewController.h"
#import "SCMyOderViewController.h"
#import "SCMyCouponViewController.h"
#import "SCUserInfoView.h"
#import "SCChangeMaintenanceDataViewController.h"

typedef NS_ENUM(NSInteger, SCUserCenterRow) {
    SCUserCenterRowMyOrder = 0,
    SCUserCenterRowMyCollection,
    SCUserCenterRowMyCoupon,
    SCUserCenterRowMyCustomers,
    SCUserCenterRowMyReservation,
};

@interface SCUserViewController () <SCUserInfoViewDelegate, SCChangeMaintenanceDataViewControllerDelegate, SCMyCouponViewControllerDelegate>

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
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Private Methods
- (void)initConfig
{
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pushToMyCouponViewController) name:kGenerateCouponSuccessNotification object:nil];
    [NOTIFICATION_CENTER addObserver:_userInfoView selector:@selector(refresh) name:kUserCarsDataNeedReloadSuccessNotification object:nil];
}

- (void)viewConfig
{
//    [self.tableView reLayoutHeaderView];
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
                    SCMyOderViewController *myOderViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyOderViewController"];
                    [self pushToSubViewControllerWithController:myOderViewController];
                }
                    break;
                case SCUserCenterRowMyCollection:
                {
                    SCMyFavoriteTableViewController *myFavoriteTableViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyFavoriteTableViewController"];
                    myFavoriteTableViewController.showTrashItem = YES;
                    [self pushToSubViewControllerWithController:myFavoriteTableViewController];
                }
                    break;
                case SCUserCenterRowMyCoupon:
                {
                    [self pushToMyCouponViewController];
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

#pragma mark - Private Methods
/**
 *  Push到一个页面，带动画
 *
 *  @param viewController 需要Push到的页面
 */
- (void)pushToSubViewControllerWithController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushToMyCouponViewController
{
    SCMyCouponViewController *myCouponViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyCouponViewController"];
    myCouponViewController.delegate = self;
    [self pushToSubViewControllerWithController:myCouponViewController];
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
    [_userInfoView refresh];
}

#pragma mark - SCMyCouponViewControllerDelegate Methods
- (void)shouldShowOderList
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:Zero inSection:Zero]];
}

@end
