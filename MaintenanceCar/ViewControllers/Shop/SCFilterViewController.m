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
- (void)initConfig {
    [super initConfig];
    _filterViewModel = [[SCFilterViewModel alloc] init];
    
    @weakify(self)
    [RACObserve([SCUserInfo share], loginState) subscribeNext:^(NSNumber *loginState) {
        @strongify(self)
        [self loadFilterData];
    }];
}

- (void)viewConfig {
    [super viewConfig];
    
    WEAK_SELF(weakSelf);
    [_filterView filterCompleted:^(NSString *param, NSString *value) {
        if (param && value) {
            [weakSelf reloadShopListWithRequestParamrter:param value:value];
        }
    }];
}

#pragma mark - Private Methods
- (void)loadFilterData {
    [_filterView restore];
    if (_filterViewModel) {
        WEAK_SELF(weakSelf);
        [_filterViewModel loadCompleted:^(SCFilterViewModel *viewModel, BOOL success) {
            if (success) {
                _filterView.filterViewModel = viewModel;
                __block SCFilterCategoryCarItem *selectedItem = nil;
                NSString *selectedUserCarID = [SCUserInfo share].selectedUserCarID;
                [viewModel.filter.carModelCategory.myCars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    SCFilterCategoryCarItem *item = obj;
                    if ([item.userCarID isEqualToString:selectedUserCarID]) {
                        selectedItem = item;
                        return;
                    }
                }];
                if (selectedItem) {
                    NSString *param = viewModel.filter.carModelCategory.program;
                    NSString *value = selectedItem.value;
                    if (param && value) {
                        [weakSelf reloadShopListWithRequestParamrter:param value:value];
                    }
                }
            }
        }];
    }
}

- (void)reloadShopListWithRequestParamrter:(NSString *)param value:(NSString *)value {
    [self resetRequestState];
    [self showLoading];
    [self.shopList.parameters setValue:value forKey:param];
    [self.shopList loadShops];
}

@end
