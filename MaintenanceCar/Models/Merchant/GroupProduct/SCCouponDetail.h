//
//  SCCouponDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCoupon.h"

@interface SCCouponDetail : SCCoupon

@property (nonatomic, copy) NSString <Optional>*old_price;
@property (nonatomic, copy) NSString <Optional>*order_id;
@property (nonatomic, copy) NSString <Optional>*pay_id;
@property (nonatomic, copy) NSString <Optional>*price;
@property (nonatomic, copy) NSString <Optional>*reserve_id;
@property (nonatomic, copy) NSString <Optional>*ticket_type;
@property (nonatomic, copy) NSString <Optional>*used_mechanic_id;
@property (nonatomic, copy) NSString <Optional>*used_time;
@property (nonatomic, copy) NSString <Optional>*used_user_id;
@property (nonatomic, copy) NSString <Optional>*content;

@end