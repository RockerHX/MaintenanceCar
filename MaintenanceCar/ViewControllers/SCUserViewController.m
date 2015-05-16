//
//  SCUserViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserViewController.h"
#import "SCLoginViewController.h"
#import "SCCollectionsViewController.h"
#import "SCUserInfoView.h"
#import "SCChangeMaintenanceDataViewController.h"

typedef NS_ENUM(NSInteger, SCUserCenterRow) {
    SCUserCenterRowOrders = 0,
    SCUserCenterRowCollections,
    SCUserCenterRowGroupTickets,
    SCUserCenterRowCoupons
};

@interface SCUserViewController () <SCUserInfoViewDelegate, SCChangeMaintenanceDataViewControllerDelegate>

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
    [NOTIFICATION_CENTER addObserver:self selector:@selector(showMyOderList) name:kShowTicketNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pushToGroupTicketsViewController) name:kGenerateTicketSuccessNotification object:nil];
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
        switch (indexPath.row)
        {
            case SCUserCenterRowOrders:
                [self pushToSubViewControllerWithController:USERCENTER_VIEW_CONTROLLER(@"SCOdersViewController")];
                break;
            case SCUserCenterRowCollections:
            {
                SCCollectionsViewController *collectionsViewController = USERCENTER_VIEW_CONTROLLER(@"SCCollectionsViewController");
                collectionsViewController.showTrashItem = YES;
                [self pushToSubViewControllerWithController:collectionsViewController];
            }
                break;
            case SCUserCenterRowGroupTickets:
                [self pushToGroupTicketsViewController];
                break;
                
            case SCUserCenterRowCoupons:
                [self pushToSubViewControllerWithController:USERCENTER_VIEW_CONTROLLER(@"SCCouponsViewController")];
                break;
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

- (void)pushToGroupTicketsViewController
{
    [self pushToSubViewControllerWithController:USERCENTER_VIEW_CONTROLLER(@"SCGroupTicketsViewController")];
}

- (void)showMyOderList
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:Zero inSection:Zero]];
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

// [设置]按钮被点击，跳转到App设置页面
- (IBAction)settingItemPressed:(UIBarButtonItem *)sender
{
    [self pushToSubViewControllerWithController:USERCENTER_VIEW_CONTROLLER(@"SCSettingViewController")];
}

// [添加车辆]按钮被点击，跳转到添加车辆页面
- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        UINavigationController *addCarViewNavigationControler = USERCENTER_VIEW_CONTROLLER(@"SCAddCarViewNavigationController");
        [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
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
    SCChangeMaintenanceDataViewController *changeMaintenanceDataViewController = MAIN_VIEW_CONTROLLER(@"SCChangeMaintenanceDataViewController");
    changeMaintenanceDataViewController.delegate = self;
    changeMaintenanceDataViewController.car = userCar;
    [self.navigationController pushViewController:changeMaintenanceDataViewController animated:YES];
}

#pragma mark - SCChangeMaintenanceDataViewControllerDelegate Methods
- (void)dataSaveSuccess
{
    [_userInfoView refresh];
}

@end
