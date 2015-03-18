//
//  SCMyCouponViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyCouponViewController.h"
#import "SCCouponHeaderView.h"
#import "SCCouponCell.h"
#import "SCCoupon.h"
#import "SCCouponDetailViewController.h"

@interface SCMyCouponViewController ()

@end

@implementation SCMyCouponViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 我的团购券"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 我的团购券"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell" forIndexPath:indexPath];
    [cell displayCellWithCoupon:_dataList[indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCoupon *coupon = _dataList[indexPath.row];
    return ![coupon expired];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCoupon *coupon = _dataList[indexPath.row];
    return [coupon expiredPrompt];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    @try {
        SCCoupon *coupon = _dataList[indexPath.row];
        SCCouponDetailViewController *couponDetailViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:@"SCCouponDetailViewController"];
        couponDetailViewController.coupon = coupon;
        [self.navigationController pushViewController:couponDetailViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMyCouponViewController Go to the SCCouponDetailViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Public Methods
/**
 *  下拉刷新，请求最新数据
 */
- (void)startDownRefreshReuqest
{
    [super startDownRefreshReuqest];
    
    // 刷新前把数据偏移量offset设置为0，设置刷新类型，以便请求最新数据
    self.offset = Zero;
    self.requestType = SCFavoriteListRequestTypeDown;
    [self startMyCouponListRequest];
}

/**
 *  上拉刷新，加载更多数据
 */
- (void)startUpRefreshRequest
{
    [super startUpRefreshRequest];
    
    // 设置刷新类型
    self.requestType = SCFavoriteListRequestTypeUp;
    [self startMyCouponListRequest];
}

#pragma mark - Private Methods
- (void)startMyCouponListRequest
{
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                 @"limit"  : @(MerchantListLimit),
                                 @"offset" : @(self.offset)};
    [[SCAPIRequest manager] startGetMyCouponAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，在做数据处理
            if (weakSelf.requestType == SCFavoriteListRequestTypeDown)
                [weakSelf clearListData];
            
            // 遍历请求回来的商家数据，生成SCCoupon用于团购券显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCCoupon *coupon = [[SCCoupon alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:coupon];
            }];
            
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:weakSelf.offset ? UITableViewRowAnimationTop : UITableViewRowAnimationFade];                                                           // 数据配置完成，刷新商家列表
            weakSelf.offset += MerchantListLimit;                                                       // 偏移量请求参数递增
        }
        else
        {
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:responseObject[@"error"] delay:0.5f];
        }
        
        [weakSelf hiddenHUD];             // 请求完成，移除响应式控件
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        // 关闭上拉刷新或者下拉刷新
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf hiddenHUD];
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"您还没有购买过过任何团购券噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
    }];
}

@end
