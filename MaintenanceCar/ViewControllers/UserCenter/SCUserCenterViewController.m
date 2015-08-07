//
//  SCUserCenterViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterViewController.h"
#import "SCAddCarViewController.h"
#import "SCOrdersViewController.h"
#import "SCCollectionsViewController.h"
#import "SCGroupTicketsViewController.h"
#import "SCCouponsViewController.h"
#import "SCUserInfoView.h"
#import "SCChangeCarDataViewController.h"

typedef NS_ENUM(NSInteger, SCUserCenterRow) {
    SCUserCenterRowOrders = 0,
    SCUserCenterRowCollections,
    SCUserCenterRowGroupTickets,
    SCUserCenterRowCoupons
};

@interface SCUserCenterViewController () <SCUserInfoViewDelegate, SCChangeCarDataViewControllerDelegate>

@end

@implementation SCUserCenterViewController

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

#pragma mark - Init Methods
+ (instancetype)instance
{
    return [SCStoryBoardManager viewControllerWithClass:self storyBoardName:SCStoryBoardNameUserCenter];
}

#pragma mark - Class Methods
+ (NSString *)navgationRestorationIdentifier
{
    return @"UserCenterNavigationController";
}

#pragma mark - Config Methods
- (void)initConfig
{
    [NOTIFICATION_CENTER addObserver:self selector:@selector(showMyOrderList) name:kShowTicketReservationNotification object:nil];
    [NOTIFICATION_CENTER addObserver:_userInfoView selector:@selector(refresh) name:kUserCarsDataNeedReloadSuccessNotification object:nil];
}

- (void)viewConfig
{
    //    [self.tableView reLayoutHeaderView];
}

#pragma mark - Action Methods
// [添加车辆]按钮被点击，跳转到添加车辆页面
- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender
{
    if ([SCUserInfo share].loginState)
    {
        UINavigationController *navigationControler = [SCAddCarViewController navigationInstance];
        [self presentViewController:navigationControler animated:YES completion:nil];
    }
    else
        [self showShoulLoginAlert];
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 检查用户是否登录，在进行相应页面跳转
    if ([SCUserInfo share].loginState)
    {
        switch (indexPath.row)
        {
            case SCUserCenterRowOrders:
                [self pushToSubViewControllerWithController:[SCOrdersViewController instance]];
                break;
            case SCUserCenterRowCollections:
            {
                SCCollectionsViewController *collectionsViewController = [SCCollectionsViewController instance];
                collectionsViewController.showTrashItem = YES;
                [self pushToSubViewControllerWithController:collectionsViewController];
            }
                break;
            case SCUserCenterRowGroupTickets:
                [self pushToGroupTicketsViewController];
                break;
                
            case SCUserCenterRowCoupons:
                [self pushToSubViewControllerWithController:[SCCouponsViewController instance]];
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
    [self pushToSubViewControllerWithController:[SCGroupTicketsViewController instance]];
}

- (void)showMyOrderList
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

#pragma mark - SCUserInfoViewDelegate Methods
- (void)shouldLogin
{
    [self checkShouldLogin];
}

- (void)shouldChangeCarData:(SCUserCar *)userCar
{
    SCChangeCarDataViewController *viewController = [SCChangeCarDataViewController instance];
    viewController.delegate = self;
    viewController.car = userCar;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SCChangeCarDataViewControllerDelegate Methods
- (void)dataSaveSuccess
{
    [_userInfoView refresh];
}

@end
