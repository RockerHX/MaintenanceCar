//
//  SCCommentListViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCommentListViewController.h"

@interface SCCommentListViewController ()

@end

@implementation SCCommentListViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[评论] - 商家评论列表"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[评论] - 商家评论列表"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
