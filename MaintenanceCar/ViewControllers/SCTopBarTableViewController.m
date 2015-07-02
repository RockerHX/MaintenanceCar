//
//  SCTopBarTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTopBarTableViewController.h"

@implementation SCTopBarTableViewController

#pragma mark - Init Methods

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化设置
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Private Methods

#pragma mark - Public Methods
- (void)initConfig{}

- (void)viewConfig
{
    self.tableView.tableFooterView = [[UIView alloc] init];         // 为tableview添加空白尾部，以免没有数据显示时有很多条纹
    
    // 为tableview添加下拉响应式控件和触发方法
    [self addRefreshHeader];
    [self addFooter];
}

- (void)resetRequestState
{
    _requestType = SCRequestRefreshTypeDropDown;
}

- (void)startDropDownRefreshReuqest
{
    _requestType = SCRequestRefreshTypeDropDown;
    [self removeRefreshFooter];
}

- (void)startPullUpRefreshRequest
{
    _requestType = SCRequestRefreshTypePullUp;
    [self removeRefreshHeader];
}

- (void)endRefresh
{
    if (_requestType == SCRequestRefreshTypeDropDown)
    {
        [self.tableView.header endRefreshing];
        [self addRefreshFooter];
    }
    else
    {
        [self.tableView.footer endRefreshing];
        [self addRefreshHeader];
    }
}

- (void)addRefreshHeader
{
    if (!self.tableView.header)
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(startDropDownRefreshReuqest)];
}

- (void)removeRefreshHeader
{
    [self.tableView removeHeader];
}

- (void)addRefreshFooter
{
    if (!self.tableView.footer)
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(startPullUpRefreshRequest)];
}

- (void)removeRefreshFooter
{
    [self.tableView removeFooter];
}

- (void)addFooter
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 10.0f)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
}

- (void)removeFooter
{
    self.tableView.tableFooterView = nil;
}

@end
