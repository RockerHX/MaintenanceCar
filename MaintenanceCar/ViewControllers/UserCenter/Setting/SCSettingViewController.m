//
//  SCSettingViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSettingViewController.h"
#import <UMengFeedback/UMFeedback.h>

@implementation SCSettingViewController

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    static UINavigationController *navigationController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        navigationController = [SCStoryBoardManager navigaitonControllerWithIdentifier:@"SettingNavigationController"
                                                                        storyBoardName:SCStoryBoardNameUserCenter];
    });
    return navigationController;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 设置"];
    [self displayView];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 设置"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    [_appMessageSwitch addTarget:self action:@selector(appMessageAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewConfig {
    [self displayView];
}

#pragma mark - Action
- (IBAction)menuButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowMenu)]) {
        [_delegate shouldShowMenu];
    }
}

- (IBAction)logoutButtonPressed {
    _appMessageSwitch.on = NO;
    [[SCUserInfo share] logout];
    [self showHUDPromptToViewController:self tag:Zero text:@"正在注销" delay:0.5f];
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        // 跳转到[友盟反馈]页面
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否联系客服"
                                                            message:@"400-686-6588"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打", nil];
        [alertView show];
    }
}

#pragma mark - Private Methods
- (void)displayView {
    SCUserInfo *userInfo = [SCUserInfo share];
    _appMessageSwitch.on = userInfo.receiveMessage;
    _logoutView.hidden   = !userInfo.loginState;
    _logoutButton.layer.cornerRadius = 5.0f;
}

- (void)appMessageAction:(UISwitch *)sender {
    SCUserInfo *userInfo = [SCUserInfo share];
    if (!userInfo.loginState) {
        _appMessageSwitch.on = NO;
        [self showHUDAlertToViewController:self text:@"您还未登录，无法接受推送消息" delay:0.5f];
    }
    userInfo.receiveMessage = sender.on;
}

#pragma mark - MBProgressHUD Delegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    _logoutView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
    }
}

@end
