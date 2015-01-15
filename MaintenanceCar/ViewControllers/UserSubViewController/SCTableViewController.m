//
//  SCTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"
#import "SCLocationInfo.h"

@interface SCTableViewController ()
{
    UIView *_hudView;
}

@end

@implementation SCTableViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化设置
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 监听手机定位，在定位结束或者定位失败后才能进行数据请求
    if ([keyPath isEqualToString:@"userLocation"])
    {
        if ([SCLocationInfo shareLocationInfo].userLocation && change[NSKeyValueChangeNewKey])
        {
            [self startDownRefreshReuqest];
        }
        else if ([SCLocationInfo shareLocationInfo].locationFailure)
        {
            [self startDownRefreshReuqest];
        }
    }
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
    
    // 监听SCLocationInfo单例的userLocation属性，观察定位是否成功
    [[SCLocationInfo shareLocationInfo] addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewConfig
{
    self.tableView.tableFooterView = [[UIView alloc] init];         // 为tableview添加空白尾部，以免没有数据显示时有很多条纹
    
    // 为tableview添加上拉和下拉响应式控件和触发方法
    [self.tableView addHeaderWithTarget:self action:@selector(startDownRefreshReuqest)];
    [self.tableView addFooterWithTarget:self action:@selector(startUpRefreshRequest)];
    
    self.clearsSelectionOnViewWillAppear = YES;                     // 清除cell的选中状态
    // 添加编辑列表的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                           target:self
                                                                                           action:@selector(changeListEditStatus)];
    
    if ([SCLocationInfo shareLocationInfo].userLocation)
    {
        [self startDownRefreshReuqest];
    }
}

- (void)startDownRefreshReuqest
{
    // 下拉刷新时，显示响应式控件，阻止用户操作
    [self showHUDToView:self.navigationController.view];
}

- (void)startUpRefreshRequest
{
    // 上拉刷新时，显示响应式控件，阻止用户操作
    [self showHUDToView:self.navigationController.view];
}

- (void)showHUDToView:(UIView *)view
{
    _hudView = view;
    [MBProgressHUD showHUDAddedTo:view animated:YES];               // 加载响应式控件
}

- (void)hiddenHUD
{
    [MBProgressHUD hideHUDForView:_hudView animated:YES];           // 隐藏响应式控件
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
