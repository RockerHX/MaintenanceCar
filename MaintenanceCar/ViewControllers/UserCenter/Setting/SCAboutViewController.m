//
//  SCAboutViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCAboutViewController.h"
#import "SCWebViewController.h"

static NSString *kADURLKey = @"kADURLKey";

@implementation SCAboutViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 关于"];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 关于"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    _logoImageView.layer.cornerRadius = 30.0f;
    _logoImageView.layer.borderWidth  = 1.0f;
    _logoImageView.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    _versionLabel.text = [NSString stringWithFormat:@"当前版本号:%@(Build %@)", version, build];
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/xiu-yang/id960929849?mt=8"]];
            break;
        }
    }
}

#pragma mark - Private Methods

@end
