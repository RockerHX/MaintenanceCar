//
//  SCPayOrderResult.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOrderResult.h"
#import "SCCoupon.h"

@implementation SCPayOrderResult

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _purchaseCount = 1;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (void)setCoupon:(SCCoupon *)coupon
{
    _coupon = coupon;
    _resultDeductiblePrice = coupon.amount.doubleValue;
}

- (NSString *)couponCode
{
    return _coupon ? _coupon.code : @"0";
}

- (NSString *)totalPrice
{
    return [NSString stringWithFormat:@"%.2f", (_resultProductPrice * _purchaseCount)];
}

- (NSString *)deductiblePrice
{
    return [NSString stringWithFormat:@"%.2f", _resultDeductiblePrice];
}

- (NSString *)payPrice
{
    double totalPrice = (_resultProductPrice * _purchaseCount) - _resultDeductiblePrice;
    return [NSString stringWithFormat:@"%.2f", (totalPrice > 0) ? totalPrice : 0];
}

- (NSString *)useCoupon
{
    return _resultDeductiblePrice ? @"Y" : @"N";
}

#pragma mark - Public Methods
- (void)setResultProductPrice:(double)productPrice
{
    _resultProductPrice = productPrice;
}

@end
