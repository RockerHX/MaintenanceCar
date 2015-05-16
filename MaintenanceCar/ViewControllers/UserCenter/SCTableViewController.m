//
//  SCTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@implementation SCTableViewController

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
- (void)changeListEditStatus
{
    // 改变列表编辑状态
    self.tableView.editing = !self.tableView.editing;
}

#pragma mark - Public Methods
- (void)initConfig
{
    _dataList = [@[] mutableCopy];                                  // 初始化列表数据缓存
}

- (void)viewConfig
{
    self.clearsSelectionOnViewWillAppear = YES;                     // 清除cell的选中状态
    // 添加编辑列表的按钮
    if (_showTrashItem)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                               target:self
                                                                                               action:@selector(changeListEditStatus)];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];         // 为tableview添加空白尾部，以免没有数据显示时有很多条纹
    
    // 为tableview添加下拉响应式控件和触发方法
    [self addRefreshHeader];
    [self.tableView.header beginRefreshing];
}

- (void)startDropDownRefreshReuqest
{
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
