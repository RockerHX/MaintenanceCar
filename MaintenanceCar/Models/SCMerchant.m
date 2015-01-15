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
- (id)initWithMerchantName:(NSString *)merchantName companyID:(NSString *)companyID
{
    self = [super init];
    if (self)
    {
        // 通过自定义方法初始化方法
        _name       = merchantName;
        _company_id = companyID;
    }
    return self;
}

#pragma mark - Getter Methods
- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
