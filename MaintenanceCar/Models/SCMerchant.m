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

#pragma mark - Setter And Getter Methods
- (void)setZige:(NSString<Optional> *)zige
{
    switch ([zige integerValue])
    {
        case 1:
            _zige = @"一";
            break;
        case 2:
            _zige = @"二";
            break;
        case 3:
            _zige = @"三";
            break;
            
        default:
            _zige = nil;
            break;
    }
}

- (void)setHonest:(NSString<Optional> *)honest
{
    if ([honest integerValue])
        _honest = @"诚";
    else
        _honest = nil;
}

- (void)setMajor_type:(NSString<Optional> *)major_type
{
    if ([major_type integerValue])
        _major_type = @"专";
    else
        _major_type = nil;
}

- (NSString *)distance
{
    // 本地处理位置距离
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
