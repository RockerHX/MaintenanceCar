//
//  SCOderPayViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderPayViewController.h"
#import <Weixin/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "SCGroupProductDetail.h"
#import "SCWeiXinPayOder.h"
#import "SCAliPayOrder.h"

typedef NS_ENUM(NSInteger, SCAliPayCode) {
    SCAliPayCodePaySuccess    = 9000,
    SCAliPayCodePayProcessing = 8000,
    SCAliPayCodePayFailure    = 4000,
    SCAliPayCodeUserCancel    = 6001,
    SCAliPayCodeNetworkError  = 6002
};

@interface SCOderPayViewController ()
{
    NSUInteger  _productCount;
    CGFloat     _productPrice;
    
    SCWeiXinPayOder *_weiXinPayOder;
    SCAliPayOrder   *_aliPayOder;
}

@end

@implementation SCOderPayViewController

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
    [_aliPayButton setTitle:[NSString stringWithFormat:@"支付宝支付%@元", _totalPriceLabel.text] forState:UIControlStateNormal];
}

//- (void)viewConfig
//{
//    self.view.backgroundColor      = UIColorWithRGBA(236.0f, 240.0f, 243.0f, 1.0f);
//    
//    UIView *footer                 = [[UIView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SCREEN_WIDTH, 40.0f)];
//    footer.backgroundColor         = [UIColor clearColor];
//    self.tableView.tableFooterView = footer;
//}

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
        if ([WXApi isWXAppInstalled])
        {
            [self showHUDOnViewController:self];
            __weak typeof(self)weakSelf = self;
            NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                      @"company_id": _groupProductDetail.companyID,
                                      @"product_id": _groupProductDetail.product_id,
                                        @"how_many": @(_productCount),
                                     @"total_price": _totalPriceLabel.text,
                                          @"mobile": [SCUserInfo share].phoneNmber};
            [[SCAPIRequest manager] startGetWeiXinPayOrderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
                {
                    _weiXinPayOder = [[SCWeiXinPayOder alloc] initWithDictionary:responseObject error:nil];
                    
                    _groupProductDetail.outTradeNo = _weiXinPayOder.out_trade_no;
                    [weakSelf sendWeiXinPay:_weiXinPayOder];
                }
                else
                    [weakSelf oderFailure];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf oderFailure];
            }];
        }
        else
            [self showWeiXinInstallAlert];
    }
    else
        [self showShoulLoginAlert];
}

- (IBAction)aliPayPressed:(id)sender
{
    if ([SCUserInfo share].loginStatus)
    {
        [self showHUDOnViewController:self];
        __weak typeof(self)weakSelf = self;
        NSDictionary *parameters = @{@"user_id": [SCUserInfo share].userID,
                                  @"company_id": _groupProductDetail.companyID,
                                  @"product_id": _groupProductDetail.product_id,
                                    @"how_many": @(_productCount),
                                 @"total_price": _totalPriceLabel.text,
                                      @"mobile": [SCUserInfo share].phoneNmber};
        [[SCAPIRequest manager] startGetAliPayOrderAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
            {
                _aliPayOder = [[SCAliPayOrder alloc] initWithDictionary:responseObject error:nil];
                
                _groupProductDetail.outTradeNo = _aliPayOder.out_trade_no;
                [weakSelf sendAliPay:_aliPayOder];
            }
            else
                [weakSelf oderFailure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf oderFailure];
        }];
    }
    else
        [self showShoulLoginAlert];
}

#pragma mark - Private Methods
- (void)oderFailure
{
    [self hideHUDOnViewController:self];
    [self showHUDAlertToViewController:self text:@"下单失败，请重试..." delay:1.0f];
}

- (void)weiXinPaySuccess
{
    [self showHUDAlertToViewController:self.navigationController text:@"恭喜您团购成功！" delay:0.5f];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [NOTIFICATION_CENTER postNotificationName:kGenerateCouponSuccessNotification object:nil];
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
            [NOTIFICATION_CENTER postNotificationName:kGenerateCouponSuccessNotification object:nil];
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

- (void)showPromptWithText:(NSString *)text
{
    [self hideHUDOnViewController:self];
    [self showHUDAlertToViewController:self text:text delay:1.0f];
}

- (void)displayView
{
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", (_productCount * _productPrice)];
    
    [_weiXinPayButton setTitle:[NSString stringWithFormat:@"微信支付%@元", _totalPriceLabel.text] forState:UIControlStateNormal];
    [_aliPayButton setTitle:[NSString stringWithFormat:@"支付宝支付%@元", _totalPriceLabel.text] forState:UIControlStateNormal];
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
