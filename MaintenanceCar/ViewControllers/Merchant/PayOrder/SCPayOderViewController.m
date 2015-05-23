//
//  SCPayOderViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderViewController.h"
#import "SCPayOderMerchandiseSummaryCell.h"
#import "SCPayOderGroupProductSummaryCell.h"
#import "SCPayOderEnterCodeCell.h"
#import "SCPayOderCouponCell.h"
#import "SCPayOderResultCell.h"
#import <Weixin/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "SCWeiXinPayOder.h"
#import "SCAliPayOrder.h"

typedef NS_ENUM(NSInteger, SCAliPayCode) {
    SCAliPayCodePaySuccess    = 9000,
    SCAliPayCodePayProcessing = 8000,
    SCAliPayCodePayFailure    = 4000,
    SCAliPayCodeUserCancel    = 6001,
    SCAliPayCodeNetworkError  = 6002
};

@interface SCPayOderViewController () <SCPayOderMerchandiseSummaryCellDelegate, SCPayOderGroupProductSummaryCellDelegate, SCPayOderResultCellDelegate>
{
    SCPayOderResult *_payResult;
    
    SCPayOderGroupProductSummaryCell *_groupProductSummaryCell;
    SCPayOderMerchandiseSummaryCell  *_merchandiseSummaryCell;
    SCPayOderResultCell              *_payResultCell;
}

@end

@implementation SCPayOderViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[买单]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[买单]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
}

- (void)dealloc
{
    [NOTIFICATION_CENTER removeObserver:self name:kWeiXinPaySuccessNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kWeiXinPayFailureNotification object:nil];
}

#pragma mark - Init Methods
+ (instancetype)instance
{
    return USERCENTER_VIEW_CONTROLLER(@"SCPayOderViewController");
}

#pragma mark - Config Methods
- (void)initConfig
{
    _payResult = [[SCPayOderResult alloc] init];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPaySuccess) name:kWeiXinPaySuccessNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPayFailure) name:kWeiXinPayFailureNotification object:nil];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ( _oderDetail || _groupProduct) ? 3 : Zero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( _oderDetail || _groupProduct) ? ((section == 1) ? 2 : 1) : Zero;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ( _oderDetail || _groupProduct)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                if (_groupProduct)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderGroupProductSummaryCell" forIndexPath:indexPath];
                    [(SCPayOderGroupProductSummaryCell *)cell displayCellWithProduct:_groupProduct];
                }
                else if (_oderDetail)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderMerchandiseSummaryCell" forIndexPath:indexPath];
                    [(SCPayOderMerchandiseSummaryCell *)cell displayCellWithDetail:_oderDetail];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderCouponCell" forIndexPath:indexPath];
//                    [(SCPayOderCouponCell *)cell displayCellWithDetail:_detail];
                }
                else
                    cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderEnterCodeCell" forIndexPath:indexPath];
            }
                break;
            case 2:
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderResultCell" forIndexPath:indexPath];
                [(SCPayOderResultCell *)cell displayCellWithResult:_payResult];
            }
                break;
        }
    }
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ZERO_POINT;
    if ( _oderDetail || _groupProduct)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                if (_groupProduct)
                {
                    if(!_groupProductSummaryCell)
                        _groupProductSummaryCell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderGroupProductSummaryCell"];
                    height = [_groupProductSummaryCell displayCellWithProduct:_groupProduct];
                }
                else if (_oderDetail)
                {
                    if(!_merchandiseSummaryCell)
                        _merchandiseSummaryCell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderMerchandiseSummaryCell"];
                    height = [_merchandiseSummaryCell displayCellWithDetail:_oderDetail];
                }
            }
                break;
            case 2:
            {
                if(!_payResultCell)
                    _payResultCell = [tableView dequeueReusableCellWithIdentifier:@"SCPayOderResultCell"];
                height = [_payResultCell displayCellWithResult:_payResult];
            }
                break;
            default:
            {
                height = 44.0f;
            }
                break;
        }
    }
    
    return height;
}

#pragma mark - Private Methods
- (void)weiXinPayWithParameters:(NSDictionary *)parameters
{
    if ([SCUserInfo share].loginStatus)
    {
        if ([WXApi isWXAppInstalled])
        {
            [self showHUDOnViewController:self];
            __weak typeof(self)weakSelf = self;
            if (_oderDetail)
            {
                [[SCAPIRequest manager] startWeiXinPayOderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [weakSelf weiXinPayRequestSuccessWithOperation:operation];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [weakSelf payFailureWithOperation:operation];
                }];
            }
            else if (_groupProduct)
            {
                [[SCAPIRequest manager] startWeiXinOderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [weakSelf weiXinPayRequestSuccessWithOperation:operation];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [weakSelf payFailureWithOperation:operation];
                }];
            }
        }
        else
            [self showWeiXinInstallAlert];
    }
    else
        [self showShoulLoginAlert];
}

- (void)aliPayWithParameters:(NSDictionary *)parameters
{
    if ([SCUserInfo share].loginStatus)
    {
        [self showHUDOnViewController:self];
        __weak typeof(self)weakSelf = self;
        if (_oderDetail)
        {
            [[SCAPIRequest manager] startAliPayOderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf aliPayRequestSuccessWithOperation:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf payFailureWithOperation:operation];
            }];
        }
        else if (_groupProduct)
        {
            [[SCAPIRequest manager] startAliOderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf aliPayRequestSuccessWithOperation:operation];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf payFailureWithOperation:operation];
            }];
        }
    }
    else
        [self showShoulLoginAlert];
}

- (void)weiXinPayRequestSuccessWithOperation:(AFHTTPRequestOperation *)operation
{
    id responseObject = operation.responseObject;
    if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
    {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeNoError:
            {
                SCWeiXinPayOder *weiXinPayOder = [[SCWeiXinPayOder alloc] initWithDictionary:responseObject[@"data"] error:nil];
                [self sendWeiXinPay:weiXinPayOder];
            }
                break;
        }
        if (statusMessage.length)
            [self showHUDAlertToViewController:self text:statusMessage];
    }
}

- (void)aliPayRequestSuccessWithOperation:(AFHTTPRequestOperation *)operation
{
    id responseObject = operation.responseObject;
    if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
    {
        NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
        NSString *statusMessage = responseObject[@"status_message"];
        switch (statusCode)
        {
            case SCAPIRequestErrorCodeNoError:
            {
                SCAliPayOrder *aliPayOder = [[SCAliPayOrder alloc] initWithDictionary:responseObject[@"data"] error:nil];
                [self sendAliPay:aliPayOder];
            }
                break;
        }
        if (statusMessage.length)
            [self showHUDAlertToViewController:self text:statusMessage];
    }
}

- (void)payFailureWithOperation:(AFHTTPRequestOperation *)operation
{
    [self oderFailureWithMessage:operation.responseObject[@"message"]];
}

- (void)oderFailureWithMessage:(NSString *)message
{
    [self showPromptWithText:message];
}

- (void)sendWeiXinPay:(SCWeiXinPayOder *)oder
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = oder.partnerid;
    request.prepayId  = oder.prepayid;
    request.package   = oder.package;
    request.nonceStr  = oder.noncestr;
    request.timeStamp = (UInt32)oder.timestamp;
    request.sign      = oder.sign;
    [WXApi sendReq:request];
}

- (void)sendAliPay:(SCAliPayOrder *)oder
{
    [self hideHUDOnViewController:self];
    __weak typeof(self)weakSelf = self;
    [[AlipaySDK defaultService] payOrder:[oder requestString] fromScheme:@"com.YJCL.XiuYang" callback:^(NSDictionary *resultDic) {
        [weakSelf alipayResult:resultDic];
    }];
}

- (void)weiXinPaySuccess
{
    [self showHUDAlertToViewController:self.navigationController text:@"恭喜您团购成功！"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NOTIFICATION_CENTER postNotificationName:kGenerateTicketSuccessNotification object:nil];
}

- (void)weiXinPayFailure
{
    [self showPromptWithText:@"支付失败，请重试..."];
}

- (void)alipayResult:(NSDictionary *)reslut
{
    switch ([reslut[@"resultStatus"] integerValue])
    {
        case SCAliPayCodePaySuccess:
        {
            [self showPromptWithText:@"支付成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [NOTIFICATION_CENTER postNotificationName:kGenerateTicketSuccessNotification object:nil];
        }
            break;
        case SCAliPayCodePayProcessing:
            [self showPromptWithText:@"交易进行中"];
            break;
        case SCAliPayCodePayFailure:
            [self showPromptWithText:@"支付失败"];
            break;
        case SCAliPayCodeUserCancel:
            [self showPromptWithText:@"用户取消"];
            break;
        case SCAliPayCodeNetworkError:
            [self showPromptWithText:@"网络错误"];
            break;
    }
}

- (void)showWeiXinInstallAlert
{
    [self showAlertWithMessage:@"您的手机还没有安装微信，请先安装微信再使用微信支付，谢谢！"];
}

- (void)showPromptWithText:(NSString *)text
{
    [self hideHUDOnViewController:self];
    [self showHUDAlertToViewController:self text:text delay:1.0f];
}

#pragma mark - SCPayOderGroupProductSummaryCellDelegate Methods
- (void)didDisplayProductPrice:(CGFloat)price
{
    [_payResult setResultTotalPrice:price];
}

- (void)didConfirmProductPrice:(CGFloat)price purchaseCount:(NSInteger)purchaseCount
{
    [_payResult setPurchaseCount:@(purchaseCount).stringValue];
    [_payResult setResultTotalPrice:price];
    [self.tableView reloadData];
}

#pragma mark - SCPayOderMerchandiseSummaryCellDelegate Methods
- (void)didConfirmMerchantPrice:(CGFloat)price
{
    [_payResult setResultTotalPrice:price];
    [self.tableView reloadData];
}

#pragma mark - SCPayOderResultCellDelegate Methods
- (void)shouldPayForOderWithPayment:(SCPayOderment)payment
{
    NSDictionary *parameters = nil;
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_oderDetail)
    {
        parameters = @{@"user_id": userInfo.userID,
                        @"mobile": userInfo.phoneNmber,
                    @"company_id": _oderDetail.companyID,
                    @"reserve_id": _oderDetail.reserveID,
                   @"total_price": _payResult.payPrice,
                     @"old_price": _payResult.totalPrice,
                    @"use_coupon": _payResult.useCoupon,
                   @"coupon_code": _payResult.couponCode};
    }
    else if (_groupProduct)
    {
        parameters = @{@"user_id": userInfo.userID,
                        @"mobile": userInfo.phoneNmber,
                    @"company_id": _groupProduct.companyID,
                    @"product_id": _groupProduct.product_id,
                      @"how_many": _payResult.purchaseCount,
                   @"total_price": _payResult.payPrice,
                     @"old_price": _payResult.totalPrice,
                    @"use_coupon": _payResult.useCoupon,
                   @"coupon_code": _payResult.couponCode};
    }
    
    switch (payment)
    {
        case SCPayOdermentWeiXinPay:
            [self weiXinPayWithParameters:parameters];
            break;
        case SCPayOdermentAliPay:
            [self aliPayWithParameters:parameters];
            break;
    }
}

@end
