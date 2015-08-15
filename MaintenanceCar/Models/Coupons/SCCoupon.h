//
//  SCCoupon.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <MJExtension/MJExtension.h>

typedef NS_ENUM(NSUInteger, SCCouponType) {
    SCCouponTypeFullCut = 1,
    SCCouponTypeDiscount,
    SCCouponTypeFree
};

@interface SCCoupon : NSObject

@property (nonatomic, assign)         BOOL  current;
@property (nonatomic, assign)         BOOL  showSymbol;
@property (nonatomic, assign) SCCouponType  type;
@property (nonatomic, copy)       NSString *ID;
@property (nonatomic, copy)       NSString *code;
@property (nonatomic, copy)       NSString *title;
@property (nonatomic, copy)       NSString *prompt;
@property (nonatomic, copy)       NSString *amount;
@property (nonatomic, copy)       NSString *amountMax;
@property (nonatomic, copy)       NSString *amountPrompt;
@property (nonatomic, copy)       NSString *needMin;
@property (nonatomic, copy)       NSString *validDate;
@property (nonatomic, copy)       NSString *memo;

@end
