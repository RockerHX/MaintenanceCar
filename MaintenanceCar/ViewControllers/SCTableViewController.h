//
//  SCTableViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "SCViewController.h"
#import "SCShopList.h"

typedef NS_ENUM(NSUInteger, SCTableViewRefreshType) {
    SCTableViewRefreshTypeDropDown,
    SCTableViewRefreshTypePullUp
};

@interface SCTableViewController : SCViewController

@property (nonatomic, assign) SCTableViewRefreshType  refreshType;  // 刷新类型，是上拉刷新还是下拉刷新
@property (nonatomic, strong)             SCShopList *shopList;

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

- (void)setRequestParameter:(NSString *)parameter value:(NSString *)value;

@end
