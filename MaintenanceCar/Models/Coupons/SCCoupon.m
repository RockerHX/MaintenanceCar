//
//  SCCoupon.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCoupon.h"

@implementation SCCoupon

+ (instancetype)objectWithKeyValues:(id)keyValues {
    SCCoupon *coupon = [super objectWithKeyValues:keyValues];
    double amount = [coupon.amount doubleValue];
    double needMin = [coupon.needMin doubleValue];
    if (needMin < amount) {
        coupon.type = SCCouponTypeFree;
    }
    
    switch (coupon.type) {
        case SCCouponTypeFullCut: {
            coupon.showSymbol = YES;
            break;
        }
        case SCCouponTypeDiscount: {
            NSInteger discount = [coupon.amount doubleValue] * 10;
            coupon.amount = [NSString stringWithFormat:@"%zd折", discount];
            break;
        }
        case SCCouponTypeFree: {
            coupon.amount = @"免费";
            break;
        }
    }
    return coupon;
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"type": @"coupon_type",
               @"ID": @"coupon_id",
           @"prompt": @"description",
          @"needMin": @"need_min",
        @"validDate": @"expiration"};
}

@end
