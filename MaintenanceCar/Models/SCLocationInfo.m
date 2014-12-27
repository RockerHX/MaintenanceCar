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

@end
