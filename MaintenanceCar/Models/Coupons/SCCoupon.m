//
//  SCCoupon.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCoupon.h"

@implementation SCCoupon

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"coupon_id": @"ID",
                                                     @"description": @"prompt",
                                                      @"expiration": @"validDate"}];
}

@end
