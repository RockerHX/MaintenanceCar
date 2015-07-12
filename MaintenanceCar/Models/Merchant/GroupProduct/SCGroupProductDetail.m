//
//  SCGroupProductDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetail.h"
#import "NumberConstants.h"
#import "SCLocationManager.h"

@implementation SCGroupProductDetail

#pragma mark - Setter And Getter Methods
- (NSString<Ignore> *)distance
{
    // 本地处理位置距离
    return [[SCLocationManager share] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

#pragma mark - Public Methods
- (BOOL)canBug
{
    return ![_sold_out integerValue];
}

@end
