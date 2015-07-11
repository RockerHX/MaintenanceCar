//
//  SCSearchViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCSearchViewController.h"
#import "SCSearchBar.h"
#import "SCSearchHistoryView.h"
#import "SCShopList.h"
#import "SCDiscoveryMerchantCell.h"
#import "SCDiscoveryPopProductCell.h"
#import "SCDiscoveryPopPromptCell.h"
#import "SCMerchantDetailViewController.h"
#import "SCGroupProductDetailViewController.h"
#import "SCSearchViewController.h"
// TODO
#import "SCGroupProduct.h"
#import "SCQuotedPrice.h"

@interface SCSearchViewController () <SCSearchBarDelegate, SCSearchHistoryViewDelegate>
{
    SCSearchHistory *_searchHistory;
}

@end

@implementation SCSearchViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    self.navigationController.navigationBarHidden = NO;
//    if (_delegate && [_delegate respondsToSelector:@selector(searchViewControllerReturnBack)])
//        [_delegate searchViewControllerReturnBack];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    self.title = @"搜索";
}

+ (instancetype)instance
{
    return SEARCH_VIEW_CONTROLLER(CLASS_NAME(self));
}

#pragma mark - Config Methods
- (void)initConfig
{
    _searchHistory = [[SCSearchHistory alloc] init];
    
    self.shopList = [[SCShopList alloc] init];
    @weakify(self)
    [RACObserve(self.shopList, loaded) subscribeNext:^(NSNumber *loaded) {
        @strongify(self)
        if (loaded.boolValue)
            [self hanleServerResponse:self.shopList.serverResponse];
    }];
}

- (void)viewConfig
{
    [super viewConfig];
    
    _searchHistoryView.searchHistory = _searchHistory;
}

#pragma mark - Public Methods
- (void)showLoadingView
{
    [super showLoadingView];
    _searchSubView.hidden = YES;
}

#pragma mark - Private Methods
- (void)startSearch:(NSString *)search
{
    [_searchBar.textField resignFirstResponder];
    [self showLoadingView];
    [self.shopList reloadShopsWithSearch:search];
}

#pragma mark - SCSearchBarDelegate Methods
- (void)shouldBackReturn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shouldSearchWithContent:(NSString *)content
{
    [_searchHistory addNewSearchHistory:content];
    [_searchHistoryView refresh];
    [self startSearch:content];
}

#pragma mark - SCSearchHistoryViewDelegate Methods
- (void)shouldSearchWithHistory:(NSString *)history
{
    [self startSearch:history];
}

@end
