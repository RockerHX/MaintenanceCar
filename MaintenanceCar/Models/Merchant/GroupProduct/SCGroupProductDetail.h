//
//  SCGroupProductDetail.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProduct.h"
#import "SCComment.h"

@interface SCGroupProductDetail : SCGroupProduct

@property (nonatomic, strong) NSString <Optional>*group_capacity;
@property (nonatomic, strong) NSString <Optional>*sold_out;
@property (nonatomic, strong) NSString <Optional>*img1;
@property (nonatomic, strong) NSString <Optional>*limit_begin;
@property (nonatomic, strong) NSString <Optional>*limit_end;
@property (nonatomic, strong) NSString <Optional>*begin_time;
@property (nonatomic, strong) NSString <Optional>*end_time;
@property (nonatomic, strong) NSString <Optional>*is_reserve;
@property (nonatomic, strong) NSString <Optional>*memo;
@property (nonatomic, strong) NSString <Optional>*exception;
@property (nonatomic, strong) NSString <Optional>*reserve_pre_day;
@property (nonatomic, strong) NSString <Optional>*telephone;
@property (nonatomic, strong) NSString <Optional>*latitude;             // 商家地理位置 - 纬度
@property (nonatomic, strong) NSString <Optional>*longtitude;           // 商家地理位置 - 经度
@property (nonatomic, strong) NSString <Optional>*address;
@property (nonatomic, strong) NSString <Optional>*star;                 // 商家星级
@property (nonatomic, assign) NSInteger           comments_num;

@property (nonatomic, strong)            NSArray <Optional>*des;
@property (nonatomic, strong) NSArray <Optional, SCComment>*comments;
@property (nonatomic, strong)           NSString <Optional>*serviceDate;
@property (nonatomic, strong, readonly) NSString   <Ignore>*distance;         // 手机当前位置与商家的距离

- (BOOL)canBug;

@end
