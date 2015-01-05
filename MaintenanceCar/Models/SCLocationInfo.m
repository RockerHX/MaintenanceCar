//
//  SCLocationInfo.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/27.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCLocationInfo.h"

static SCLocationInfo *locationInfo = nil;

@implementation SCLocationInfo

#pragma mark - Init Methods
#pragma mark -
- (id)init
{
    self = [super init];
    if (self) {
        _city = @"深圳";          // 第一版针对深圳市场，默认为深圳
    }
    return self;
}

+ (instancetype)shareLocationInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationInfo = [[SCLocationInfo alloc] init];
    });
    return locationInfo;
}

#pragma mark - Private Methods
#pragma mark -
/**
 *  得到用于APP上显示的实际距离（实际距离小于1000米时显示单位为米M，精确度为10米；大于1000米是显示单位为千米KM）
 *
 *  @param serverDistance 从服务器上请求得到的距离
 *
 *  @return 用于APP显示的距离
 */
- (NSString *)displayDistance:(CLLocationDistance)distance
{
    NSString *displayDistance = @"";
    if (distance < 1000.f)
    {
        displayDistance = [NSString stringWithFormat:@"%ldm", (long)distance];
    }
    else
    {
        displayDistance = [NSString stringWithFormat:@"%.1fkm", distance/1000.0f];
    }
    return displayDistance;
}

#pragma mark - Getter Methods
#pragma mark -
// 重构经纬度getter方法，处理经纬度数据
- (NSString *)latitude
{
    NSString *latitude = _location ? [@(_location.coordinate.latitude) stringValue] : nil;
    if (!latitude)
    {
        latitude = @"";
    }
    return latitude;
}

- (NSString *)longitude
{
    NSString *longitude = _location ? [@(_location.coordinate.longitude) stringValue] : nil;
    if (!longitude)
    {
        longitude = @"";
    }
    return longitude;
}

#pragma mark - Public Methods
#pragma mark -
- (NSString *)distanceWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocation *merchantLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLLocationDistance distance = [_location distanceFromLocation:merchantLocation];
    return [self displayDistance:distance];
}

@end
