//
//  SCTableViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCTableViewController.h"

@implementation SCTableViewController {
    NSMutableDictionary *_requestParameters;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化设置
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Public Methods
- (void)initConfig {
    _hasRreshHeader = YES;
    _shopList = [[SCShopList alloc] init];
    if (_requestParameters) {
        [_shopList addParameters:_requestParameters];
    }
    
    @weakify(self)
    [RACObserve(_shopList, loaded) subscribeNext:^(NSNumber *loaded) {
        @strongify(self)
        if (loaded.boolValue)
            [self hanleServerResponse:_shopList.serverResponse];
    }];
    [_shopList loadShops];
}

- (void)viewConfig {
    _tableView.scrollsToTop = YES;
    _tableView.tableFooterView = [[UIView alloc] init];         // 为tableview添加空白尾部，以免没有数据显示时有很多条纹
    
    // 为tableview添加下拉响应式控件和触发方法
    if (_hasRreshHeader) {
        [self addRefreshHeader];
    }
    [self addFooter];
}

- (void)resetRequestState {
    _refreshType = SCTableViewRefreshTypeDropDown;
}

- (void)startDropDownRefreshReuqest {
    _refreshType = SCTableViewRefreshTypeDropDown;
    [self removeRefreshFooter];
}

- (void)startPullUpRefreshRequest {
    _refreshType = SCTableViewRefreshTypePullUp;
    [self removeRefreshHeader];
}

- (void)endRefresh {
    if (_refreshType == SCTableViewRefreshTypeDropDown) {
        [self.tableView.header endRefreshing];
        [self addRefreshFooter];
    } else {
        [self.tableView.footer endRefreshing];
        [self addRefreshHeader];
    }
}

- (void)addRefreshHeader {
    if (!self.tableView.header) {
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(startDropDownRefreshReuqest)];
    }
}

- (void)removeRefreshHeader {
    [self.tableView removeHeader];
}

- (void)addRefreshFooter {
    if (!self.tableView.footer) {
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(startPullUpRefreshRequest)];
    }
}

- (void)removeRefreshFooter {
    [self.tableView removeFooter];
}

- (void)addFooter {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 10.0f)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
}

- (void)removeFooter {
    self.tableView.tableFooterView = nil;
}

- (void)setRequestParameter:(NSString *)parameter value:(NSString *)value {
    if (!_requestParameters) {
        _requestParameters = @{}.mutableCopy;
    }
    if (parameter && value) {
        [_requestParameters setValue:value forKey:parameter];
    }
}

@end
