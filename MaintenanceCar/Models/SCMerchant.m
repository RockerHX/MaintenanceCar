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

#pragma mark - Private Methods
#pragma mark -

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)distance
{
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
