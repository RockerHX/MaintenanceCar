//
//  SCSearchViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchViewController.h"
#import "SCSearchBar.h"
#import "SCSearchHistoryView.h"

@interface SCSearchViewController () <SCSearchBarDelegate>
{
    SCSearchHistory *_searchHistory;
}

@end

@implementation SCSearchViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[搜索]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[搜索]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _searchHistory = [[SCSearchHistory alloc] init];
}

- (void)viewConfig
{
    _searchHistoryView.searchHistory = _searchHistory;
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return SEARCH_VIEW_CONTROLLER(CLASS_NAME(self));
}

#pragma mark - Search Bar Delegate Methods
- (void)shouldBackReturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shouldSearchWithContent:(NSString *)content
{
    [_searchHistory addNewSearchHistory:content];
    [_searchHistoryView refresh];
}

@end
