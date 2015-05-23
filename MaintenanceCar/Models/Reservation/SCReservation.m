//
//  SCReservation.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservation.h"

@implementation SCReservation

#pragma mark - Init Mehtods
- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    self = [super initWithDictionary:dict error:err];
    if (self)
    {
        _status = [self handleMaintenanceSchedule];
        _reserve_time = [NSString stringWithFormat:@"%@ ~ %@:00", _reserve_time, @([[_reserve_time substringWithRange:(NSRange){6,2}] integerValue] + 1)];
    }
    return self;
}

#pragma mark - Private Methods
- (NSString *)handleMaintenanceSchedule
{
    NSString  *schedule = nil;
    NSInteger state     = [_status integerValue];
    switch(state)
    {
        case 1:
        {
            schedule    = @"预约成功";
            _orderStatus = SCOrderStatusServationSuccess;
        }
            break;
        case 2:
        {
            schedule    = @"商家未接受";
            _orderStatus = SCOrderStatusMerchantUnAccepted;
        }
            break;
        case 3:
        {
            schedule    = @"业务进行中";
            _orderStatus = SCOrderStatusInProgress;
        }
            break;
        case 4:
        {
            schedule    = @"预约已取消";
            _orderStatus = SCOrderStatusServationCancel;
        }
            break;
        case 5:
        {
            schedule    = @"已完成";
            _orderStatus = SCOrderStatusCompleted;
        }
            break;
        case 6:
        {
            schedule    = @"已过期";
            _orderStatus = SCOrderStatusExpired;
        }
            break;
        default:
        {
            schedule    = @"商家确认中";
            _orderStatus = SCOrderStatusMerchantConfirming;
        }
            break;
    }
    return schedule;
}

#pragma mark - Public Methods
- (BOOL)canUnReservation
{
    return ((_orderStatus == SCOrderStatusMerchantConfirming) || (_orderStatus == SCOrderStatusServationSuccess));
}

- (BOOL)canShowResult
{
    return [_type isEqualToString:@"免费检测"] && (_orderStatus == SCOrderStatusCompleted);
}

- (BOOL)isAppraised
{
    return _comment.detail.length ? YES : NO;
}

- (SCOrderType)orderType
{
    if ((_orderStatus == SCOrderStatusInProgress) || (_orderStatus == SCOrderStatusCompleted))
    {
        if ([self canShowResult])
            return [self isAppraised] ? SCOrderTypeAppraisedCheck : SCOrderTypeUnAppraisalCheck;
        else
            return [self isAppraised] ? SCOrderTypeAppraised : SCOrderTypeUnAppraisal;
    }
    else
        return SCOrderTypeNormal;
}

@end
