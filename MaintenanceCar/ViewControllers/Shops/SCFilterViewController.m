//
//  SCFilterViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterViewController.h"

@implementation SCFilterViewController

#pragma mark - Config Methods
- (void)initConfig
{
    [super initConfig];
    _filterViewModel = [[SCFilterViewModel alloc] init];
    [_filterViewModel loadCompleted:^(SCFilterViewModel *viewModel, BOOL success) {
        if (success)
            _filterView.filterViewModel = viewModel;
    }];
}

- (void)viewConfig
{
    [super viewConfig];
    
    WEAK_SELF(weakSelf);
    [_filterView filterCompleted:^(NSString *param, NSString *value) {
        [weakSelf resetRequestState];
        [weakSelf showLoadingView];
        [weakSelf.shopList.parameters setValue:value forKey:param];
        [weakSelf.shopList reloadShops];
    }];
}

@end
