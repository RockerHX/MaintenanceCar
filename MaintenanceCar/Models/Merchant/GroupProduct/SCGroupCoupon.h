//
//  SCGroupCoupon.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, SCGroupCouponState) {
    SCGroupCouponStateUnUse,
    SCGroupCouponStateUsed,
    SCGroupCouponStateCancel,
    SCGroupCouponStateExpired,
    SCGroupCouponStateRefunding,
    SCGroupCouponStateRefunded,
    SCGroupCouponStateReserved,
    SCGroupCouponStateUnknown
};

@interface SCGroupCoupon : JSONModel

@property (nonatomic, copy) NSString <Optional>*group_ticket_id;
@property (nonatomic, copy) NSString <Optional>*company_id;
@property (nonatomic, copy) NSString <Optional>*code;
@property (nonatomic, copy) NSString <Optional>*product_id;
@property (nonatomic, copy) NSString <Optional>*limit_begin;
@property (nonatomic, copy) NSString <Optional>*limit_end;
@property (nonatomic, copy) NSString <Optional>*user_id;
@property (nonatomic, copy) NSString <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*sell_count;
@property (nonatomic, copy) NSString <Optional>*status;
@property (nonatomic, copy) NSString <Optional>*final_price;
@property (nonatomic, copy) NSString <Optional>*total_price;
@property (nonatomic, copy) NSString <Optional>*company_name;
@property (nonatomic, copy) NSString <Optional>*now;

@property (nonatomic, assign, readonly) SCGroupCouponState state;

- (BOOL)expired;
- (NSString *)expiredPrompt;

@end