//
//  SCSettingTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSettingTableViewController.h"
#import <UMengAnalytics/MobClick.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "UMFeedback.h"
#import "SCUserInfo.h"

@interface SCSettingTableViewController () <MBProgressHUDDelegate, UIAlertViewDelegate>

@end

@implementation SCSettingTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 设置"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 设置"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
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
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        // 跳转到[友盟反馈]页面
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否联系客服"
                                                            message:@"400-686-6588"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打", nil];
        [alertView show];
    }
}

#pragma mark - Private Methods
- (void)initConfig
{
    [_appMessageSwitch addTarget:self action:@selector(appMessageAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewConfig
{
    [self displayView];
}

- (void)displayView
{
    SCUserInfo *userInfo = [SCUserInfo share];
    _appMessageSwitch.on             = userInfo.receiveMessage;
    _logoutView.hidden               = !userInfo.loginStatus;
    _logoutButton.layer.cornerRadius = 5.0f;
}

- (void)appMessageAction:(UISwitch *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (!userInfo.loginStatus)
    {
        _appMessageSwitch.on = NO;
        ShowPromptHUDWithText(self.view, @"您还为登录，无法接受维修消息", 0.5f);
    }
    userInfo.receiveMessage = sender.on;
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay delegate:(id<MBProgressHUDDelegate>)delegate
{
    MBProgressHUD *hud            = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate                  = delegate;
    hud.mode                      = MBProgressHUDModeIndeterminate;
    hud.labelText                 = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    _appMessageSwitch.on = NO;
    [[SCUserInfo share] logout];
    [self showPromptHUDWithText:@"正在注销" delay:1.0f delegate:self];
}

#pragma mark - MBProgressHUD Delegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    _logoutView.hidden = YES;
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
}

@end
