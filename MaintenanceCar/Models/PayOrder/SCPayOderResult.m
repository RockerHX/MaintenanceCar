//
//  SCPayOderResult.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderResult.h"

@implementation SCPayOderResult

#pragma mark - Init Methods
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _purchaseCount = @"1";
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (NSString *)couponCode
{
    return _couponCode ? _couponCode : @"0";
}

- (NSString *)totalPrice
{
    return [NSString stringWithFormat:@"%.2f", (_resultTotalPrice)];
}

- (NSString *)deductiblePrice
{
    return [NSString stringWithFormat:@"%.2f", (_resultDeductiblePrice)];
}

- (NSString *)payPrice
{
    return [NSString stringWithFormat:@"%.2f", (_resultPayPrice)];
}

- (NSString *)useCoupon
{
    return _resultDeductiblePrice ? @"Y" : @"N";
}

#pragma mark - Public Methods
- (void)setResultTotalPrice:(double)resultTotalPrice
{
    _resultTotalPrice = resultTotalPrice;
    _resultPayPrice = resultTotalPrice - _resultDeductiblePrice;
}

- (void)setResultDeductiblePrice:(double)resultDeductiblePrice
{
    _resultDeductiblePrice = resultDeductiblePrice;
    _resultPayPrice = _resultTotalPrice - resultDeductiblePrice;
}

@end
