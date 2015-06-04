//
//  SCAliPayOrder.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "SCAliPayOrder.h"

@implementation SCAliPayOrder

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"_input_charset": @"inputCharset",
                                                            @"seller_id": @"sellerID",
                                                         @"out_trade_no": @"outTradeNo",
                                                            @"total_fee": @"totalFee",
                                                           @"notify_url": @"notifyURL",
                                                         @"payment_type": @"paymentType",
                                                             @"it_b_pay": @"itBPay",
                                                             @"show_url": @"showURL",
                                                            @"sign_type": @"signType"}];
}

- (NSString *)requestString
{
	NSMutableString *order = [NSMutableString string];
    if (_partner)
        [order appendFormat:@"partner=\"%@\"", _partner];
    if (_sellerID)
        [order appendFormat:@"&seller_id=\"%@\"", _sellerID];
	if (_outTradeNo)
        [order appendFormat:@"&out_trade_no=\"%@\"", _outTradeNo];
	if (_subject)
        [order appendFormat:@"&subject=\"%@\"", _subject];
	if (_body)
        [order appendFormat:@"&body=\"%@\"", _body];
	if (_totalFee)
        [order appendFormat:@"&total_fee=\"%@\"", _totalFee];
    if (_notifyURL)
        [order appendFormat:@"&notify_url=\"%@\"", _notifyURL];
    if (_service)
        [order appendFormat:@"&service=\"%@\"", _service];                   //mobile.securitypay.pay
    if (_paymentType)
        [order appendFormat:@"&payment_type=\"%@\"", _paymentType];         //1
    if (_inputCharset)
        [order appendFormat:@"&_input_charset=\"%@\"", _inputCharset];      //utf-8
    if (_itBPay)
        [order appendFormat:@"&it_b_pay=\"%@\"", _itBPay];                 //30m
    if (_showURL)
        [order appendFormat:@"&show_url=\"%@\"", _showURL];                 //m.alipay.com
    if (_rsaDate)
        [order appendFormat:@"&sign_date=\"%@\"", _rsaDate];
    if (_appID)
        [order appendFormat:@"&app_id=\"%@\"", _appID];
    
    return [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   order, _sign, _signType];;
}

@end
