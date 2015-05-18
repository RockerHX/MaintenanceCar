//
//  SCInvalidCouponsViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCInvalidCouponsViewController.h"
#import "SCCouponCell.h"
#import "SCCouponDetailViewController.h"
#import "SCWebViewController.h"

@implementation SCInvalidCouponsViewController
{
    NSMutableArray *_coupons;
    SCCouponCell   *_couponCell;
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[优惠券] - 已使用/过期"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[优惠券] - 已使用/过期"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    [self startInvalidCouponsRequest];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _coupons = [@[] mutableCopy];
}

- (void)viewConfig
{
    _promptView.layer.shadowColor = [UIColor grayColor].CGColor;
    _promptView.layer.shadowOpacity = 1.0f;
    _promptView.layer.shadowRadius = 6.0f;
}

#pragma mark - Action Methods
- (IBAction)ruleButtonPressed
{
    SCWebViewController *webViewController = MAIN_VIEW_CONTROLLER(@"SCWebViewController");
    webViewController.title = @"优惠券使用规则";
    webViewController.loadURL = @"";
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _coupons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell" forIndexPath:indexPath];
    
    if (_coupons.count)
    {
        cell.canNotUse = YES;
        [cell displayCellWithCoupon:_coupons[indexPath.row]];
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = Zero;
    if (_coupons.count)
    {
        if(!_couponCell)
            _couponCell = [tableView dequeueReusableCellWithIdentifier:@"SCCouponCell"];
        height = [_couponCell displayCellWithCoupon:_coupons[indexPath.row]];
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SCCouponDetailViewController *couponDetailViewController = USERCENTER_VIEW_CONTROLLER(@"SCCouponDetailViewController");
    couponDetailViewController.couponCanNotUse = YES;
    couponDetailViewController.coupon = _coupons[indexPath.row];
    [self.navigationController pushViewController:couponDetailViewController animated:YES];
}

#pragma mark - Private Methods
- (void)startInvalidCouponsRequest
{
    [self showHUDOnViewController:self];
    __weak typeof(self) weakSelf = self;
    // 配置请求参数
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID};
    [[SCAPIRequest manager] startInvalidCouponsAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode)
            {
                case SCAPIRequestErrorCodeNoError:
                {
                    [_coupons removeAllObjects];
                    [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        SCCoupon *coupon = [[SCCoupon alloc] initWithDictionary:obj error:nil];
                        [_coupons addObject:coupon];
                    }];
                    
                    [weakSelf.tableView reloadData];
                }
                    break;
            }
            if (statusMessage.length)
                [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hanleFailureResponseWtihOperation:operation];
        [weakSelf hideHUDOnViewController:weakSelf];
    }];
}

@end
