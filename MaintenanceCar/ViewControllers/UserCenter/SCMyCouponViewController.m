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
#import "SCReservationViewController.h"
#import "SCServiceItem.h"
#import "SCMerchant.h"

@interface SCMyCouponViewController () <SCCouponCodeCellDelegate>

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
    cell.delegate      = self;
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
- (void)startDropDownRefreshReuqest
{
    [super startDropDownRefreshReuqest];
    
    [self startMyCouponListRequest];
}

- (void)startPullUpRefreshRequest
{
    [super startPullUpRefreshRequest];
    
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
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            // 如果是下拉刷新数据，先清空列表，再做数据处理
            if (weakSelf.requestType == SCRequestRefreshTypeDropDown)
                [weakSelf clearListData];
            
            // 遍历请求回来的商家数据，生成SCCoupon用于团购券显示
            [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SCCoupon *coupon = [[SCCoupon alloc] initWithDictionary:obj error:nil];
                [_dataList addObject:coupon];
            }];
            
            [weakSelf.tableView reloadData];                // 数据配置完成，刷新商家列表
            weakSelf.offset += MerchantListLimit;           // 偏移量请求参数递增
        }
        else
        {
            NSLog(@"status code error:%@", [NSHTTPURLResponse localizedStringForStatusCode:operation.response.statusCode]);
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:responseObject[@"error"] delay:0.5f];
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get merchant list request error:%@", error);
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"您还没有购买过过任何团购券噢！" delay:0.5f];
        else
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
        [weakSelf endRefresh];
    }];
}

#pragma mark - SCCouponCodeCell Delegate Methods
- (void)couponShouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    @try {
        SCCoupon *coupon = _dataList[index];
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.isGroup                      = YES;
        reservationViewController.merchant                     = [[SCMerchant alloc] initWithMerchantName:coupon.company_name
                                                                            companyID:coupon.company_id];
        reservationViewController.reservationType              = coupon.type;
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

@end
