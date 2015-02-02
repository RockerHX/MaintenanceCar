//
//  SCMerchant.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchant.h"
#import "SCLocationInfo.h"

@implementation SCMerchant

#pragma mark - Public Methods
- (id)initWithMerchantName:(NSString *)merchantName
                 companyID:(NSString *)companyID
                  openTime:(NSString *)openTime
                 closeTime:(NSString *)closeTime
{
    self = [super init];
    if (self)
    {
        // 通过自定义方法初始化方法
        _name       = merchantName;
        _company_id = companyID;
        _openTime   = openTime;
        _closeTime  = closeTime;
    }
    return self;
}

#pragma mark - Setter And Getter Methods
- (void)setFlags:(NSString<Optional> *)flags
{
    _flags = flags;
    if (flags)
        _merchantFlags = [flags componentsSeparatedByString:@","];
}

- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
