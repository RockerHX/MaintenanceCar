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

@property (nonatomic, copy)  NSString <Optional>*group_capacity;
@property (nonatomic, copy)  NSString <Optional>*img1;
@property (nonatomic, copy)  NSString <Optional>*limit_begin;
@property (nonatomic, copy)  NSString <Optional>*limit_end;
@property (nonatomic, copy)  NSString <Optional>*begin_time;
@property (nonatomic, copy)  NSString <Optional>*end_time;
@property (nonatomic, copy)  NSString <Optional>*is_reserve;
@property (nonatomic, copy)  NSString <Optional>*memo;
@property (nonatomic, copy)  NSString <Optional>*exception;
@property (nonatomic, copy)  NSString <Optional>*reserve_pre_day;
@property (nonatomic, assign)         NSInteger comments_num;

@property (nonatomic, strong)            NSArray <Optional>*des;
@property (nonatomic, strong) NSArray <Optional, SCComment>*comments;

@property (nonatomic, copy)   NSString <Optional>*outTradeNo;

@end
