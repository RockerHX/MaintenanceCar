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

@interface SCUserViewController ()

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
}

#pragma mark - Button Action Methods
#pragma mark -
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    @try {
        if ([[SCUserInfo share] loginStatus] == SCLoginStatusLogout)
        {
            SCLoginViewController *loginViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCLoginViewController"];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        SCException(@"Go to the SCLoginViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
