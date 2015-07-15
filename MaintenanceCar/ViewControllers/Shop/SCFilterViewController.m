//
//  SCFilterViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCFilterViewController.h"

@implementation SCFilterViewController

#pragma mark - Config Methods
- (void)initConfig
{
    [super initConfig];
    _filterViewModel = [[SCFilterViewModel alloc] init];
    
    @weakify(self)
    [RACObserve([SCUserInfo share], loginState) subscribeNext:^(NSNumber *loginState) {
        @strongify(self)
        [self loadFilterData];
    }];
}

- (void)viewConfig
{
    [super viewConfig];
    
    WEAK_SELF(weakSelf);
    [_filterView filterCompleted:^(NSString *param, NSString *value) {
        [weakSelf resetRequestState];
        [weakSelf showLoading];
        [weakSelf.shopList.parameters setValue:value forKey:param];
        [weakSelf.shopList loadShops];
    }];
}

#pragma mark - Private Methods
- (void)loadFilterData
{
    [_filterView restore];
    if (_filterViewModel)
    {
        [_filterViewModel loadCompleted:^(SCFilterViewModel *viewModel, BOOL success) {
            if (success)
                _filterView.filterViewModel = viewModel;
        }];
    }
}

@end
