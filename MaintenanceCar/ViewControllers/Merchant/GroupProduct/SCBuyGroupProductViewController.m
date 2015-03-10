//
//  SCBuyGroupProductViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCBuyGroupProductViewController.h"
#import "SCGroupProductDetail.h"
#import "WXApi.h"
#import "SCWeiXinPay.h"

@interface SCBuyGroupProductViewController ()
{
    NSUInteger  _productCount;
    CGFloat     _productPrice;
    
    SCWeiXinPay *_weiXinPay;
}

@end

@implementation SCBuyGroupProductViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[团购] - 团购支付"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[团购] - 团购支付"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _productCount = 1;
    _productPrice = [_groupProductDetail.final_price doubleValue];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPaySuccess) name:kWeiXinPaySuccessNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPayFailure) name:kWeiXinPayFailureNotification object:nil];
}

- (void)viewConfig
{
    _productNameLabel.text = _groupProductDetail.title;
    _merchantNameLabel.text = _groupProductDetail.merchantName;
    _groupPriceLabel.text = _groupProductDetail.final_price;
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = _groupProductDetail.final_price;
}

#pragma mark - Action Methods
- (IBAction)cutButtonPressed:(id)sender
{
    _productCount = _productCount - 1;
    if (_productCount < 1)
        _productCount = 1;
    [self displayView];
}

- (IBAction)addButtonPressed:(id)sender
{
    _productCount = _productCount + 1;
    [self displayView];
}

- (IBAction)weiXinPayPressed:(id)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        __weak typeof(self)weakSelf = self;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                     @"company_id": _groupProductDetail.companyID,
                                     @"product_id": _groupProductDetail.product_id,
                                     @"how_many": @(_productCount),
                                     @"total_price": _totalPriceLabel.text};
        [[SCAPIRequest manager] startGetWeiXinPayOrderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            {
                _weiXinPay = [[SCWeiXinPay alloc] initWithDictionary:responseObject error:nil];
                
                _groupProductDetail.outTradeNo = _weiXinPay.out_trade_no;
                [weakSelf sendWeiXinPay:_weiXinPay];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ShowPromptHUDWithText(weakSelf.view, @"下单失败，请重试...", 0.5f);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    else
        [self showShoulLoginAlert];
}

#pragma mark - Private Methods
- (void)weiXinPaySuccess
{
    [self startGenerateGroupProductRequest];
}

- (void)weiXinPayFailure
{
    ShowPromptHUDWithText(self.view, @"支付失败！请重试..", 1.0f);
}

- (void)displayView
{
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", (_productCount * _productPrice)];
}

#warning @"微信SDK"真机调试和上传记得打开注释
- (void)sendWeiXinPay:(SCWeiXinPay *)pay
{
//    PayReq *request = [[PayReq alloc] init];
//    request.partnerId = pay.partnerid;
//    request.prepayId  = pay.prepayid;
//    request.package   = pay.package;
//    request.nonceStr  = pay.noncestr;
//    request.timeStamp = pay.timestamp;
//    request.sign      = pay.sign;
//    [WXApi sendReq:request];
}

- (void)startGenerateGroupProductRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                              @"company_id": _groupProductDetail.companyID,
                              @"product_id": _groupProductDetail.product_id,
                                 @"content": _groupProductDetail.title,
                               @"old_price": _groupProductDetail.total_price,
                                   @"price": _groupProductDetail.final_price,
                             @"limit_begin": _groupProductDetail.limit_begin,
                               @"limit_end": _groupProductDetail.limit_end,
                                @"how_many": @(_productCount),
                                  @"mobile": [USER_DEFAULT objectForKey:kPhoneNumberKey],
                                @"order_id": _groupProductDetail.outTradeNo};
    [[SCAPIRequest manager] startGenerateGroupProductAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            ShowPromptHUDWithText(weakSelf.navigationController.view, @"恭喜您团购成功！", 1.0f);
            [self.navigationController popToRootViewControllerAnimated:YES];
            [NOTIFICATION_CENTER postNotificationName:kGenerateCouponSuccessNotification object:nil];
        }
        else
            [weakSelf showGenerateCouponFailureAlert];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (operation.response.statusCode == SCAPIRequestStatusCodeNotFound)
            [weakSelf showGenerateCouponFailureAlert];
        else
            ShowPromptHUDWithText(weakSelf.navigationController.view, NetWorkError, 0.5f);
    }];
}

- (void)showGenerateCouponFailureAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的网络好像出问题了，请您检查网络，重新购买。之前支付的款项将在3天内自动退回您的银行卡！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 用户选择是否登录
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        [self checkShouldLogin];
    }
}

@end
