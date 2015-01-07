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
#pragma mark -
- (id)initWithMerchantName:(NSString *)merchantName companyID:(NSString *)companyID
{
    self = [super init];
    if (self)
    {
        _name       = merchantName;
        _company_id = companyID;
    }
    return self;
}

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)distance
{
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
