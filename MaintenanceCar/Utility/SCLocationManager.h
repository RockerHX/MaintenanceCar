//
//  SCLocationManager.h
//
//  Copyright (c) 2014年 ShiCang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Baidu-Maps-iOS-SDK/BMapKit.h>

// 用户位置信息Model - 单例，全局使用
@interface SCLocationManager : NSObject

@property (nonatomic, copy, readonly)          NSString *city;         // 当前所在城市
@property (nonatomic, copy, readonly)          NSString *latitude;     // 当前位置 - 纬度
@property (nonatomic, copy, readonly)          NSString *longitude;    // 当前位置 - 经度

@property (nonatomic, strong, readonly) BMKUserLocation *userLocation; // 当前地理位置信息(百度坐标)

@property (nonatomic, assign, readonly)            BOOL locationFailure;

/**
 *  用户位置信息Model初始化方法 - 单例
 *
 *  @return 用户位置信息Model实例
 */
+ (instancetype)share;

/**
 *  计算一个经纬度到当前位置的距离
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 *
 *  @return 距离
 */
- (NSString *)distanceWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

/**
 *  获取位置数据
 *
 *  @param success 获取成功的回调
 *  @param failure 获取失败的回调
 */
- (void)getLocationSuccess:(void(^)(BMKUserLocation *userLocation, NSString *latitude, NSString *longitude))success
                   failure:(void(^)(NSString *latitude, NSString *longitude, NSError *error))failure;

@end
