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

#define ZERO_PRICE              0
#define UN_SELECTED_CODE        @"0"

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _canPay = YES;
        _purchaseCount = 1;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (BOOL)priceConfirm
{
    return _resultProductPrice ? YES : NO;
}

- (void)setCoupon:(SCCoupon *)coupon
{
    _coupon = coupon;
    _resultDeductiblePrice = coupon.amount.doubleValue;
}

- (NSString *)couponCode
{
    return _coupon ? _coupon.code : UN_SELECTED_CODE;
}

- (NSString *)totalPrice
{
    return [NSString stringWithFormat:@"%.2f", [self resultTotalPrice]];
}

- (NSString *)deductiblePrice
{
    return [NSString stringWithFormat:@"%.2f", _resultDeductiblePrice];
}

- (NSString *)payPrice
{
    double payPrice = [self resultTotalPrice] - _resultDeductiblePrice;
    return [NSString stringWithFormat:@"%.2f", payPrice ? payPrice : 0];
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

- (BOOL)checkCouponCanUse
{
    if (self.totalPrice.doubleValue <= _coupon.needMin.doubleValue)
    {
        self.coupon = nil;
        return YES;
    }
    return NO;
}

#pragma mark - Private Methods
- (double)resultTotalPrice
{
    return (_resultProductPrice * _purchaseCount);
}

@end
