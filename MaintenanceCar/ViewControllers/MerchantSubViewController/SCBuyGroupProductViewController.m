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
    NSUInteger _productCount;
    double     _productPrice;
}

@end

@implementation SCBuyGroupProductViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[团购支付]"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:@"[团购支付]"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (_productCount > [_groupProducDetail.sell_count integerValue])
        _productCount = [_groupProducDetail.sell_count integerValue];
    [self displayView];
}

- (IBAction)weiXinPayPressed:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[SCAPIRequest manager] startGetWeiXinPayOrderAPIRequestWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == 200)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            SCWeiXinPay *weiXinPay = [[SCWeiXinPay alloc] initWithDictionary:responseObject error:nil];
            [self sendWeiXinPay:weiXinPay];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _productCount = 1;
    _productPrice = [_groupProducDetail.final_price doubleValue];
}

- (void)viewConfig
{
    _productNameLabel.text = _groupProducDetail.title;
    _merchantNameLabel.text = _groupProducDetail.merchantName;
    _groupPriceLabel.text = _groupProducDetail.final_price;
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = _groupProducDetail.final_price;
}

- (void)displayView
{
    _productCountLabel.text = [@(_productCount) stringValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", (_productCount * _productPrice)];
}

- (void)sendWeiXinPay:(SCWeiXinPay *)pay
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = pay.partnerid;
    request.prepayId  = pay.prepayid;
    request.package   = pay.package;
    request.nonceStr  = pay.noncestr;
    request.timeStamp = pay.timestamp;
    request.sign      = pay.sign;
    [WXApi sendReq:request];
}

@end
