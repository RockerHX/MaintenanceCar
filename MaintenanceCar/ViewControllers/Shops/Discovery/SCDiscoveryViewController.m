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
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return DISCOVERY_VIEW_CONTROLLER(NSStringFromClass([self class]));
}

#pragma mark - Config Methods
- (void)initConfig
{
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
    self.tableView.scrollsToTop = YES;
    WEAK_SELF(weakSelf);
    [_filterView filterCompleted:^(NSString *param, NSString *value) {
        [weakSelf showLoadingView];
        [_shopList.parameters setValue:value forKey:param];
        [_shopList reloadShops];
    }];
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
        // 根据选中的商家，取到其商家ID，跳转到商家页面进行详情展示
        SCMerchantDetailViewController *merchantDetialViewControler = [SCMerchantDetailViewController instance];
        merchantDetialViewControler.merchant = [[SCMerchant alloc] initWithMerchantName:shopViewModel.shop.name companyID:shopViewModel.shop.ID];
        merchantDetialViewControler.canSelectedReserve = YES;
        [self.navigationController pushViewController:merchantDetialViewControler animated:YES];
    }
    else if ([cell isKindOfClass:[SCDiscoveryPopProductCell class]])
    {
        
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

#pragma mark - Public Methods
- (void)hanleServerResponse:(SCServerResponse *)response
{
    [self.tableView reloadData];
    if (response.statusCode == SCAPIRequestErrorCodeNoError)
    {
        if (response.firstLoad)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    [super hanleServerResponse:response];
}

@end
