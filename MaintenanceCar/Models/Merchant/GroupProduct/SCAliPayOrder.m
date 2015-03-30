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
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"_input_charset": @"input_charset"}];
}

- (NSString *)requestString
{
	NSMutableString *oder = [NSMutableString string];
    if (_partner)
        [oder appendFormat:@"partner=\"%@\"", _partner];
    if (_seller_id)
        [oder appendFormat:@"&seller_id=\"%@\"", _seller_id];
	if (_out_trade_no)
        [oder appendFormat:@"&out_trade_no=\"%@\"", _out_trade_no];
	if (_subject)
        [oder appendFormat:@"&subject=\"%@\"", _subject];
	if (_body)
        [oder appendFormat:@"&body=\"%@\"", _body];
	if (_total_fee)
        [oder appendFormat:@"&total_fee=\"%@\"", _total_fee];
    if (_notify_url)
        [oder appendFormat:@"&notify_url=\"%@\"", _notify_url];
    if (_service)
        [oder appendFormat:@"&service=\"%@\"", _service];                   //mobile.securitypay.pay
    if (_payment_type)
        [oder appendFormat:@"&payment_type=\"%@\"", _payment_type];         //1
    if (_input_charset)
        [oder appendFormat:@"&_input_charset=\"%@\"", _input_charset];      //utf-8
    if (_it_b_pay)
        [oder appendFormat:@"&it_b_pay=\"%@\"", _it_b_pay];                 //30m
    if (_show_url)
        [oder appendFormat:@"&show_url=\"%@\"", _show_url];                 //m.alipay.com
    if (_rsaDate)
        [oder appendFormat:@"&sign_date=\"%@\"", _rsaDate];
    if (_appID)
        [oder appendFormat:@"&app_id=\"%@\"", _appID];
    
    return [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                   oder, _sign, _sign_type];;
}


@end
