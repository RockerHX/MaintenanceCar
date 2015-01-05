//
//  SCMerchantDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetail.h"
#import "SCLocationInfo.h"

@implementation SCMerchantDetail

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)distance
{
    return [[SCLocationInfo shareLocationInfo] distanceWithLatitude:[_latitude doubleValue] longitude:[_longtitude doubleValue]];
}

@end
