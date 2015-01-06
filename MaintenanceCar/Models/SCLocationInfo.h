//
//  SCLocationInfo.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/27.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

// 用户位置信息Model - 单例，全局使用
@interface SCLocationInfo : NSObject

@property (nonatomic, copy  )        NSString *city;         // 当前所在城市
@property (nonatomic, copy  )        NSString *latitude;     // 当前位置 - 纬度
@property (nonatomic, copy  )        NSString *longitude;    // 当前位置 - 经度

@property (nonatomic, strong) BMKUserLocation *userLocation; // 当前地理位置信息(百度坐标)

/**
 *  用户位置信息Model初始化方法 - 单例
 *
 *  @return 用户位置信息Model实例
 */
+ (instancetype)shareLocationInfo;

/**
 *  计算一个经纬度到当前位置的距离
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *
 *  @return 距离
 */
- (NSString *)distanceWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
