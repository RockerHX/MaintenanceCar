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

@property (nonatomic, weak)           SCCoupon *coupon;
@property (nonatomic, assign)           double purchaseCount;
@property (nonatomic, copy, readonly) NSString *couponCode;
@property (nonatomic, copy, readonly) NSString *totalPrice;
@property (nonatomic, copy, readonly) NSString *deductiblePrice;
@property (nonatomic, copy, readonly) NSString *payPrice;
@property (nonatomic, copy, readonly) NSString *useCoupon;

- (void)setResultProductPrice:(double)productPrice;

@end
