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

@interface SCUserViewController () <UIAlertViewDelegate>

@end

@implementation SCUserViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[我] - 个人中心"];
}

- (void)viewWillDisappear:(BOOL)animated
{
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
#pragma mark -
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
        switch (indexPath.row)
        {
            case 2:
            {
                SCMyFavoriteTableViewController *myFavoriteTableViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCMyFavoriteTableViewController"];
                [self pushToSubViewControllerWithController:myFavoriteTableViewController];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Button Action Methods
#pragma mark -
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self checkShouldLogin];
}

#pragma mark - Private Methods
#pragma mark -
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
#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

@end
