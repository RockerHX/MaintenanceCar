//
//  SCGroupCouponsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupCouponsViewController.h"
#import "SCGroupCouponCell.h"
#import "SCCouponDetailViewController.h"
#import "SCReservationViewController.h"

@interface SCGroupCouponsViewController () <SCCouponCodeCellDelegate, SCReservationViewControllerDelegate>
@end

@implementation SCGroupCouponsViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 团购券"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 团购券"];
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
    SCGroupCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCGroupCouponCell" forIndexPath:indexPath];
    cell.delegate      = self;
    [cell displayCellWithCoupon:_dataList[indexPath.row] index:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGroupCoupon *coupon = _dataList[indexPath.row];
    return ![coupon expired];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table View Delegate Methods
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCGroupCoupon *coupon = _dataList[indexPath.row];
    return [coupon expiredPrompt];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCGroupCoupon *coupon = _dataList[indexPath.row];
    SCCouponDetailViewController *couponDetailViewController = USERCENTER_VIEW_CONTROLLER(@"SCCouponDetailViewController");
    couponDetailViewController.coupon = coupon;
    [self.navigationController pushViewController:couponDetailViewController animated:YES];
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
                                   @"limit": @(SearchLimit),
                                  @"offset": @(self.offset)};
    [[SCAPIRequest manager] startGroupCouponsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                        SCGroupCoupon *coupon = [[SCGroupCoupon alloc] initWithDictionary:obj error:nil];
                        [_dataList addObject:coupon];
                    }];
                    
                    weakSelf.offset += SearchLimit;               // 偏移量请求参数递增
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

#pragma mark - SCCouponCodeCellDelegate Methods
- (void)couponShouldReservationWithIndex:(NSInteger)index
{
    // 跳转到预约页面
    [[SCUserInfo share] removeItems];
    SCGroupCoupon *coupon = _dataList[index];
    SCReservationViewController *reservationViewController = MAIN_VIEW_CONTROLLER(ReservationViewControllerStoryBoardID);
    reservationViewController.delegate    = self;
    reservationViewController.merchant    = [[SCMerchant alloc] initWithMerchantName:coupon.company_name
                                                                           companyID:coupon.company_id];
    reservationViewController.serviceItem = [[SCServiceItem alloc] initWithServiceID:coupon.type];
    reservationViewController.groupCoupon = _dataList[index];
    [self.navigationController pushViewController:reservationViewController animated:YES];
}

- (void)couponShouldShowWithIndex:(NSInteger)index
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NOTIFICATION_CENTER postNotificationName:kShowCouponNotification object:nil];
}

#pragma mark - SCReservationViewControllerDelegate Methods
- (void)reservationSuccess
{
    [self startDropDownRefreshReuqest];
}

@end
