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
#import "SCCouponDetailViewController.h"
#import "SCReservationViewController.h"

@interface SCMyCouponViewController () <SCCouponCodeCellDelegate, SCReservationViewControllerDelegate>
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
    [cell displayCellWithCoupon:_dataList[indexPath.row] index:indexPath.row];
    
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
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    if (weakSelf.requestType == SCRequestRefreshTypeDropDown)
                        [weakSelf clearListData];
                    // 遍历请求回来的订单数据，生成SCCoupon用于团购券列表显示
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCCoupon *coupon = [[SCCoupon alloc] initWithDictionary:obj error:nil];
                        [_dataList addObject:coupon];
                    }];
                    
                    weakSelf.offset += MerchantListLimit;               // 偏移量请求参数递增
                    [weakSelf.tableView reloadData];                    // 数据配置完成，刷新商家列表
                    [weakSelf addRefreshHeader];
                    [weakSelf addRefreshFooter];
                }
                    break;
                    
                case SCAPIRequestErrorCodeListNotFoundMore:
                {
                    [weakSelf addRefreshHeader];
                    [weakSelf removeRefreshFooter];
                }
                    break;
            }
            if (![statusMessage isEqualToString:@"success"])
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
        }
        [weakSelf endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf endRefresh];
    }];
}

#pragma mark - SCCouponCodeCell Delegate Methods
- (void)couponShouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    @try {
        [[SCUserInfo share] removeItems];
        SCCoupon *coupon = _dataList[index];
        SCReservationViewController *reservationViewController = [STORY_BOARD(@"Main") instantiateViewControllerWithIdentifier:ReservationViewControllerStoryBoardID];
        reservationViewController.delegate                     = self;
        reservationViewController.canChange                    = NO;
        reservationViewController.merchant                     = [[SCMerchant alloc] initWithMerchantName:coupon.company_name
                                                                                                companyID:coupon.company_id];
        reservationViewController.serviceItem                  = [[SCServiceItem alloc] initWithServiceID:coupon.type];
        reservationViewController.coupon                       = _dataList[index];
        [self.navigationController pushViewController:reservationViewController animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"SCMerchantViewController Go to the SCReservationViewController exception reasion:%@", exception.reason);
    }
    @finally {
    }
}

- (void)couponShouldShowWithIndex:(NSInteger)index
{
    [self.navigationController popViewControllerAnimated:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowOderList)])
        [_delegate shouldShowOderList];
}

#pragma mark - SCReservationViewControllerDelegate Methods
- (void)reservationSuccess
{
    [self startDropDownRefreshReuqest];
}

@end
