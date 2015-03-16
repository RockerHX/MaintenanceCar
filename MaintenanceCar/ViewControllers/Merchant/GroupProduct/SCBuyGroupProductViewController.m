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

- (void)awakeFromNib
{
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16.0f;
}

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
    [MobClick endLogPageView:@"[团购] - 团购支付"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)dealloc
{
    [NOTIFICATION_CENTER removeObserver:self name:kWeiXinPaySuccessNotification object:nil];
    [NOTIFICATION_CENTER removeObserver:self name:kWeiXinPayFailureNotification object:nil];
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
    _productCountLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _productCountLabel.layer.borderWidth = 1.0f;
    _cutButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cutButton.layer.borderWidth = 1.0f;
    _addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addButton.layer.borderWidth = 1.0f;
    
    _productNameLabel.text = _groupProductDetail.title;
    _merchantNameLabel.text = _groupProductDetail.merchantName;
    _groupPriceLabel.text = _groupProductDetail.final_price;
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = _groupProductDetail.final_price;
    
    [_weiXinPayButton setTitle:[NSString stringWithFormat:@"微信支付%@元", _totalPriceLabel.text] forState:UIControlStateNormal];
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
//        if ([WXApi isWXAppInstalled])
//        {
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
                [weakSelf showHUDAlertToViewController:weakSelf text:@"下单失败，请重试..." delay:0.5f];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
//        }
//        else
//            [self showWeiXinInstallAlert];
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
    [self showHUDAlertToViewController:self text:@"下单失败，请重试..." delay:0.5f];
}

- (void)displayView
{
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", (_productCount * _productPrice)];
    
    [_weiXinPayButton setTitle:[NSString stringWithFormat:@"微信支付%@元", _totalPriceLabel.text] forState:UIControlStateNormal];
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
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:@"恭喜您团购成功！" delay:0.5f];
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
            [weakSelf showHUDAlertToViewController:weakSelf.navigationController text:NetWorkError delay:0.5f];
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

- (void)showWeiXinInstallAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"您的手机还没有安装微信，请先安装微信再使用微信支付，谢谢！"
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
