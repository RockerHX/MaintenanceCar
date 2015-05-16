//
//  SCNavigationTableViewController.m
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#import "SCNavigationTableViewController.h"

@implementation SCNavigationTableViewController

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
- (void)initConfig
{
    _dataList = [@[] mutableCopy];                                  // 初始化列表数据缓存
}

- (void)viewConfig
{
    self.tableView.tableFooterView = [[UIView alloc] init];         // 为tableview添加空白尾部，以免没有数据显示时有很多条纹
    
    // 为tableview添加下拉响应式控件和触发方法
    [self addRefreshHeader];
    [self.tableView.header beginRefreshing];
}

- (void)restartDropDownRefreshRequest
{
    [self removeFooter];
    [self removeRefreshFooter];
    
    [self clearListData];
    [self.tableView reloadData];
    
    [self addRefreshHeader];
    [self.tableView.header beginRefreshing];
}

- (void)startDropDownRefreshReuqest
{
    [self removeFooter];
    [self removeRefreshFooter];
    
    self.offset = Zero;
    self.requestType = SCRequestRefreshTypeDropDown;
}

- (void)startPullUpRefreshRequest
{
    [self removeRefreshHeader];
    self.requestType = SCRequestRefreshTypePullUp;
}

- (void)endRefresh
{
    if (_requestType == SCRequestRefreshTypeDropDown)
        [self.tableView.header endRefreshing];
    else
        [self.tableView.footer endRefreshing];
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
    if (!self.tableView.tableFooterView)
    {
        UIView *footer                 = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 10.0f)];
        footer.backgroundColor         = [UIColor clearColor];
        self.tableView.tableFooterView = footer;
    }
}

- (void)removeFooter
{
    self.tableView.tableFooterView = nil;
}

- (void)clearListData
{
    [_dataList removeAllObjects];                                   // 清空数据缓存
}

- (void)deleteFailureAtIndex:(NSInteger)index
{
    self.tableView.editing = NO;                                    // 改变列表编辑状态
    [_dataList insertObject:_deleteDataCache atIndex:index];        // 从数据缓存中删除某一条数据
    [self.tableView reloadData];                                    // 刷新tableview
}

@end
