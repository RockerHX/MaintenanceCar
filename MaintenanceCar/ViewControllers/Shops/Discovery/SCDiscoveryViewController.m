//
//  SCDiscoveryViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SCDiscoveryViewController.h"
#import "SCDiscoveryMerchantCell.h"
#import "SCDiscoveryPopProductCell.h"
#import "SCDiscoveryPopPromptCell.h"
#import "SCShopList.h"
#import "SCFilterViewModel.h"
#import "SCFilterView.h"
#import "SCMerchantDetailViewController.h"
#import "SCGroupProductDetailViewController.h"
// TODO
#import "SCGroupProduct.h"
#import "SCQuotedPrice.h"

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

#pragma mark - Init Methods
+ (instancetype)instance
{
    return DISCOVERY_VIEW_CONTROLLER(NSStringFromClass([self class]));
}

#pragma mark - Config Methods
- (void)initConfig
{
    [super initConfig];
    
    _shopList = [[SCShopList alloc] init];
    @weakify(self)
    [RACObserve(_shopList, loaded) subscribeNext:^(NSNumber *loaded) {
        @strongify(self)
        if (loaded.boolValue)
            [self hanleServerResponse:_shopList.serverResponse];
    }];
    [_shopList reloadShops];
    _filterViewModel = [[SCFilterViewModel alloc] init];
    [_filterViewModel loadCompleted:^(SCFilterViewModel *viewModel, BOOL success) {
        if (success)
            _filterView.filterViewModel = viewModel;
    }];
}

- (void)viewConfig
{
    [super viewConfig];
    
    self.tableView.scrollsToTop = YES;
    WEAK_SELF(weakSelf);
    [_filterView filterCompleted:^(NSString *param, NSString *value) {
        [weakSelf resetRequestState];
        [weakSelf showLoadingView];
        [_shopList.parameters setValue:value forKey:param];
        [_shopList reloadShops];
    }];
}

#pragma mark - Private Methods
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    
    [_shopList reloadShops];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    
    [_shopList loadMoreShops];
}

- (void)hanleServerResponse:(SCServerResponse *)response
{
    [self endRefresh];
    [self.tableView reloadData];
    
    switch (response.statusCode)
    {
        case SCAPIRequestErrorCodeNoError:
        {
            if (_shopList.shops.count < SearchLimit)
                [self removeRefreshFooter];
            if (response.firstLoad)
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
            break;
        case SCAPIRequestErrorCodeListNotFoundMore:
            [self removeRefreshFooter];
            break;
    }
    [super hanleServerResponse:response];
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
        [cell displayCellWithPrompt:data openUp:shopViewModel.isProductsOpen canPop:shopViewModel.canOpen];
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
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SCShopViewModel *shopViewModel = _shopList.shops[indexPath.section];
    if ([cell isKindOfClass:[SCDiscoveryMerchantCell class]])
    {
        // TODO
        SCMerchantDetailViewController *viewControler = [SCMerchantDetailViewController instance];
        viewControler.merchant = [[SCMerchant alloc] initWithMerchantName:shopViewModel.shop.name companyID:shopViewModel.shop.ID];
        viewControler.canSelectedReserve = YES;
        [self.navigationController pushViewController:viewControler animated:YES];
    }
    else if ([cell isKindOfClass:[SCDiscoveryPopProductCell class]])
    {
        SCShopProduct *product = shopViewModel.shop.products[indexPath.row - 1];
        SCGroupProductDetailViewController *viewController = [SCGroupProductDetailViewController instance];
        
        if (product.isGroup)
        {
            SCGroupProduct *groupProduct = [[SCGroupProduct alloc] init];
            groupProduct.product_id = product.ID;
            viewController.product = groupProduct;
        }
        else
        {
            SCQuotedPrice *price = [[SCQuotedPrice alloc] init];
            price.product_id     = product.ID;
            price.merchantName   = shopViewModel.shop.name;
            price.companyID      = shopViewModel.shop.ID;
            price.title          = product.title;
            price.final_price    = product.discountPrice;
            price.total_price    = product.discountPrice;
            viewController.title = @"商品详情";
            viewController.price = price;
        }
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if ([cell isKindOfClass:[SCDiscoveryPopPromptCell class]])
    {
        WEAK_SELF(weakSelf);
        [shopViewModel operateProductsMenu:^(BOOL shouldReload, BOOL close) {
            if (shouldReload)
            {
                [weakSelf.tableView reloadData];
                if (close)
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }];
    }
}

@end