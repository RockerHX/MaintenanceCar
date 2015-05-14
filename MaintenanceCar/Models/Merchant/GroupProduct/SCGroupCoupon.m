//
//  SCGroupCoupon.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupCoupon.h"
#import "UIConstants.h"

@implementation SCGroupCoupon

#pragma mark - Init Methods
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        _state = [self couponState];
    }
    return self;
}

#pragma mark - Public Methods
- (BOOL)expired
{
    return ([self expiredInterval] < Zero);
}

- (NSString *)expiredPrompt
{
    NSTimeInterval expiredInterval = [self expiredInterval] / (60*60*24);
    
    return [self expired] ? @"": [NSString stringWithFormat:@"还有%@天过期", @((NSInteger)expiredInterval)];
}

#pragma mark - Private Methods
- (NSTimeInterval)expiredInterval
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *expiredDate = [formatter dateFromString:_limit_end];
    NSDate *serviceDate = [formatter dateFromString:_now];
    NSTimeInterval expiredInterval = [expiredDate timeIntervalSinceDate:serviceDate];
    
    return expiredInterval;
}

- (SCGroupCouponState)couponState
{
    SCGroupCouponState state;
    switch ([_status integerValue])
    {
        case 0:
            state = SCGroupCouponStateUnUse;
            break;
        case 1:
            state = SCGroupCouponStateUsed;
            break;
        case 2:
            state = SCGroupCouponStateCancel;
            break;
        case 3:
            state = SCGroupCouponStateExpired;
            break;
        case 4:
            state = SCGroupCouponStateRefunding;
            break;
        case 5:
            state = SCGroupCouponStateRefunded;
            break;
        case 6:
            state = SCGroupCouponStateReserved;
            break;
            
        default:
            state = [self expired] ? SCGroupCouponStateExpired : SCGroupCouponStateUnknown;
            break;
    }
    return state;
}

@end
