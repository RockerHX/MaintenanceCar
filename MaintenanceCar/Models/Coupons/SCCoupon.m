//
//  SCCoupon.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCoupon.h"

@implementation SCCoupon

#pragma mark - Init Methods
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
            coupon.amountPrompt = coupon.amount;
            break;
        }
        case SCCouponTypeDiscount: {
            NSInteger discount = [coupon.amount doubleValue] * 10;
            coupon.amountPrompt = [NSString stringWithFormat:@"%zd折", discount];
            break;
        }
        case SCCouponTypeFree: {
            coupon.amountPrompt = @"免费";
            break;
        }
    }
    return coupon;
}

#pragma mark - Class Methods
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"type": @"coupon_type",
               @"ID": @"coupon_id",
           @"prompt": @"description",
        @"amountMax": @"amount_max",
          @"needMin": @"need_min",
        @"validDate": @"expiration"};
}

@end
