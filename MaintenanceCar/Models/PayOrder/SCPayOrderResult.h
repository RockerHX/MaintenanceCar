//
//  SCPayOrderResult.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCCoupon;

typedef NS_ENUM(NSUInteger, SCPayOrderment) {
    SCPayOrdermentWeiXinPay,
    SCPayOrdermentAliPay
};

@interface SCPayOrderResult : NSObject
{
    double _resultProductPrice;
    double _resultDeductiblePrice;
}

@property (nonatomic, assign)               BOOL  canPay;
@property (nonatomic, assign)             double  purchaseCount;
@property (nonatomic, strong)           SCCoupon *coupon;
@property (nonatomic, strong)           NSString *outTradeNo;
@property (nonatomic, strong, readonly) NSString *couponCode;
@property (nonatomic, strong, readonly) NSString *totalPrice;
@property (nonatomic, strong, readonly) NSString *deductiblePrice;
@property (nonatomic, strong, readonly) NSString *payPrice;
@property (nonatomic, strong, readonly) NSString *useCoupon;

- (void)setResultProductPrice:(double)productPrice;
- (BOOL)checkCouponCanUse;

@end
