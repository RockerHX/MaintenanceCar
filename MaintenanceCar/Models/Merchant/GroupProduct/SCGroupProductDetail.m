//
//  SCGroupProductDetail.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetail.h"
#import "MicroCommon.h"

@implementation SCGroupProductDetail

#pragma mark - Private Methods
- (NSTimeInterval)expiredInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *expiredDate = [formatter dateFromString:_limit_end];
    NSDate *serviceDate = [formatter dateFromString:_serviceDate];
    NSTimeInterval expiredInterval = [expiredDate timeIntervalSinceDate:serviceDate];
    
    return expiredInterval;
}

#pragma mark - Public Methods
- (BOOL)canBug
{
    if (_serviceDate)
        return ([self expiredInterval] > Zero);
    return NO;
}

@end
