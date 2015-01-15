//
//  SCUserViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCUserViewController.h"
#import <UMengAnalytics/MobClick.h>
#import "MicroCommon.h"
#import "SCUserInfo.h"
#import "SCLoginViewController.h"
#import "SCMyFavoriteTableViewController.h"
#import "SCMyReservationTableViewController.h"
#import "SCAddCarViewController.h"

typedef NS_ENUM(NSInteger, SCUserCenterRow) {
    SCUserCenterRowMyOrder = 0,
    SCUserCenterRowMyCustomers,
    SCUserCenterRowMyReservation,
    SCUserCenterRowMyCollection
};

@interface SCUserViewController () <UIAlertViewDelegate, SCAddCarViewControllerDelegate>

@end

@implementation SCUserViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[我] - 个人中心"];
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
    // Do any additional setup after loading the view.
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
    
    if (![SCUserInfo share].loginStatus)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登陆"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登陆", nil];
        [alertView show];
    }
    else
    {
        @try {
            switch (indexPath.row)
            {
                case SCUserCenterRowMyReservation:
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
            SCException(@"User Center Push Controller Error:%@", exception.reason);
        }
        @finally {
        }
    }
}

#pragma mark - Button Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self checkShouldLogin];
}

#pragma mark - Private Methods
- (void)viewConfig
{
}

- (void)pushToSubViewControllerWithController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)checkShouldLogin
{
    if (![SCUserInfo share].loginStatus)
    {
        [NOTIFICATION_CENTER postNotificationName:kUserNeedLoginNotification object:nil];
    }
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender
{
    if (![SCUserInfo share].loginStatus)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没有登陆"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登陆", nil];
        [alertView show];
    }
    else
    {
        @try {
            UINavigationController *addCarViewNavigationControler = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCAddCarViewNavigationController"];
            SCAddCarViewController *addCarViewController = (SCAddCarViewController *)addCarViewNavigationControler.topViewController;
            addCarViewController.delegate = self;
            [self presentViewController:addCarViewNavigationControler animated:YES completion:nil];
        }
        @catch (NSException *exception) {
            SCException(@"SCMyReservationTableViewController Go to the SCAddCarViewNavigationControler exception reasion:%@", exception.reason);
        }
        @finally {
        }
    }
}

#pragma mark - SCAddCarViewController Delegate Methods
- (void)addCarSuccessWith:(NSString *)userCarID
{
    NSLog(@"%@", userCarID);
}

@end
