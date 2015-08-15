//
//  SCPayOrderResult.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOrderResult.h"
#import "SCCoupon.h"

static const double ZerPrice = 0;
static NSString *const UnSelectedCode = @"0";

@implementation SCPayOrderResult

#pragma mark - Init Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        _canPay = YES;
        _purchaseCount = 1;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (BOOL)priceConfirm {
    return _resultProductPrice ? YES : NO;
}

- (void)setCoupon:(SCCoupon *)coupon {
    _coupon = coupon;
    if (!coupon) _resultDeductiblePrice = ZerPrice;
    double amount = coupon.amount.doubleValue;
    double amountMax = coupon.amountMax.doubleValue;
    
    switch (coupon.type) {
        case SCCouponTypeFullCut: {
            _resultDeductiblePrice = amount;
            break;
        }
        case SCCouponTypeDiscount: {
            _resultDeductiblePrice = amount * [self resultTotalPrice];
            if (_resultDeductiblePrice > amountMax) {
                _resultDeductiblePrice = amountMax;
            }
            break;
        }
        case SCCouponTypeFree: {
            double totalPrice = [self resultTotalPrice];
            _resultDeductiblePrice = (totalPrice > amountMax) ? amountMax : totalPrice;
            break;
        }
    }
}

- (NSString *)couponCode {
    return _coupon ? _coupon.code : UnSelectedCode;
}

- (NSString *)totalPrice {
    return [NSString stringWithFormat:@"%.2f", [self resultTotalPrice]];
}

- (NSString *)deductiblePrice {
    return [NSString stringWithFormat:@"%.2f", _resultDeductiblePrice];
}

- (NSString *)payPrice {
    double payPrice = [self resultTotalPrice] - ([self checkCouponCanUse] ? _resultDeductiblePrice : ZerPrice);
    return [NSString stringWithFormat:@"%.2f", payPrice ? payPrice : ZerPrice];
}

- (NSString *)useCoupon {
    return _resultDeductiblePrice ? @"Y" : @"N";
}

#pragma mark - Public Methods
- (void)setResultProductPrice:(double)productPrice {
    _resultProductPrice = productPrice;
}

#pragma mark - Private Methods
- (double)resultTotalPrice {
    return (_resultProductPrice * _purchaseCount);
}

- (BOOL)checkCouponCanUse {
    if (self.totalPrice.doubleValue >= _coupon.needMin.doubleValue) return YES;
    return NO;
}

@end
