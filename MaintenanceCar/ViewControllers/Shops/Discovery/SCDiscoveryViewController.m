//
//  SCDiscoveryViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryViewController.h"
#import "SCDiscoveryMerchantCell.h"
#import "SCDiscoveryPopProductCell.h"
#import "SCDiscoveryPopPromptCell.h"
#import "SCShopList.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SCDiscoveryViewController ()
@end

@implementation SCDiscoveryViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[发现]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[发现]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shopList = [[SCShopList alloc] init];
    @weakify(self)
    [RACObserve(_shopList, shopsLoaded) subscribeNext:^(id x) {
        @strongify(self)
        NSNumber *shopsLoaded = x;
        if (shopsLoaded.boolValue)
        {
            NSLog(@"serverPrompt:%@", _shopList.serverPrompt);
            [self.tableView reloadData];
        }
    }];
    [_shopList loadMoreShops];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return DISCOVERY_VIEW_CONTROLLER(@"SCDiscoveryViewController");
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _shopList.shops.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SCShopViewModel *shopViewModel = _shopList.shops[section];
    return shopViewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopViewModel *shopViewModel = _shopList.shops[indexPath.section];
    id data = shopViewModel.dataSource[indexPath.row];
    if ([data isKindOfClass:[SCShopViewModel class]])
    {
        SCDiscoveryMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDiscoveryMerchantCell" forIndexPath:indexPath];
        [cell displayCellWithShopViewModel:data];
        return cell;
    }
    else if ([data isKindOfClass:[NSString class]])
    {
        SCDiscoveryPopPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDiscoveryPopPromptCell" forIndexPath:indexPath];
        [cell displayCellWithPrompt:data pop:shopViewModel.isProductsPop];
        return cell;
    }
    SCDiscoveryPopProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCDiscoveryPopProductCell" forIndexPath:indexPath];
    [cell displayCellWithProduct:data index:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCShopViewModel *shopViewModel = _shopList.shops[indexPath.section];
    id data = shopViewModel.dataSource[indexPath.row];
    if ([data isKindOfClass:[SCShopViewModel class]])
        return 120.0f;
    else if ([data isKindOfClass:[NSString class]])
        return 32.0f;
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
