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

static NSString *const SearchNavViewController = @"SearchNavgationViewController";

@interface SCSearchViewController () <SCSearchBarDelegate, SCSearchHistoryViewDelegate> {
    SCSearchHistory *_searchHistory;
}
@end

@implementation SCSearchViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[搜索]"];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[搜索]"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
- (void)awakeFromNib {
    self.title = @"搜索";
}

+ (UINavigationController *)navigationInstance {
    return [SCStoryBoardManager navigaitonControllerWithIdentifier:SearchNavViewController storyBoardName:SCStoryBoardNameSearch];
}

#pragma mark - Config Methods
- (void)initConfig {
    _searchHistory = [[SCSearchHistory alloc] init];
    
    self.shopList = [[SCShopList alloc] init];
    @weakify(self)
    [RACObserve(self.shopList, loaded) subscribeNext:^(NSNumber *loaded) {
        @strongify(self)
        if (loaded.boolValue)
            [self hanleServerResponse:self.shopList.serverResponse];
    }];
}

- (void)viewConfig {
    [super viewConfig];
    _searchHistoryView.searchHistory = _searchHistory;
}

#pragma mark - Private Methods
- (void)startSearch:(NSString *)search {
    [_searchBar.textField resignFirstResponder];
    [self showLoading];
    [self.shopList loadShopsWithSearch:search];
}

#pragma mark - Public Methods
- (void)showLoading {
    [super showLoading];
    _searchSubView.hidden = YES;
}

#pragma mark - SCSearchBar Delegate
- (void)shouldBackReturn {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.duration = 0.2f;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)shouldResearch {
    _searchSubView.hidden = NO;
}

- (void)shouldSearchWithContent:(NSString *)content {
    if (content.length) {
        [_searchHistory addNewSearchHistory:content];
        [_searchHistoryView refresh];
        [self startSearch:content];
    } else {
        [self showAlertWithMessage:@"请您先输入搜索内容！"];
    }
}

#pragma mark - SCSearchHistoryView Delegate
- (void)shouldSearchWithHistory:(NSString *)history {
    [self startSearch:history];
}

@end
