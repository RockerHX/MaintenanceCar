//
//  SCWeiXinPayOrder.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/28.
//  Copyright (c) 2015年 WeiXinPayDemo. All rights reserved.
//

#import "SCWeiXinPayOrder.h"

@implementation SCWeiXinPayOrder

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"out_trade_no": @"outTradeNo"}];
}

@end
