//
//  SCTopBarTableViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface SCTopBarTableViewController : SCViewController

@property (nonatomic, assign) SCRequestRefreshType requestType;    // 请求类型，是上拉刷新还是下拉刷新

@property (weak, nonatomic) IBOutlet  UITableView *tableView;

// 配置方法
- (void)initConfig;
- (void)viewConfig;

- (void)resetRequestState;

// 刷新请求方法
- (void)startDropDownRefreshReuqest;
- (void)startPullUpRefreshRequest;

// 结束刷新方法
- (void)endRefresh;
- (void)addRefreshHeader;
- (void)removeRefreshHeader;
- (void)addRefreshFooter;
- (void)removeRefreshFooter;
- (void)addFooter;
- (void)removeFooter;

@end
