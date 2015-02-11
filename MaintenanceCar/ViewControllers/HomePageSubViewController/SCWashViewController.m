//
//  SCWashViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCWashViewController.h"
#import <UMengAnalytics/MobClick.h>

@interface SCWashViewController ()
{
    BOOL              _isPush;
}

@end

@implementation SCWashViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[首页 - 洗车]"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _isPush = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[首页 - 洗车]"];
    
    // 由于首页无导航栏设计，退出保养页面的时候隐藏导航栏
    if (!_isPush)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 进入保养页面的时候显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initConfig
{
}

- (void)viewConfig
{
    
}

@end
