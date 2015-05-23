//
//  SCPayOrderResult.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCPayOrderment) {
    SCPayOrdermentWeiXinPay,
    SCPayOrdermentAliPay
};

@interface SCPayOrderResult : NSObject
{
    double _resultTotalPrice;
    double _resultDeductiblePrice;
    double _resultPayPrice;
}

@property (nonatomic, copy)           NSString *purchaseCount;
@property (nonatomic, copy)           NSString *couponCode;
@property (nonatomic, copy, readonly) NSString *totalPrice;
@property (nonatomic, copy, readonly) NSString *deductiblePrice;
@property (nonatomic, copy, readonly) NSString *payPrice;
@property (nonatomic, copy, readonly) NSString *useCoupon;

- (void)setResultTotalPrice:(double)resultTotalPrice;
- (void)setResultDeductiblePrice:(double)resultDeductiblePrice;

@end
