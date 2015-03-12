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
        _type = [NSString stringWithFormat:@"%@：", _type];
        _status = [self handleMaintenanceSchedule];
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
            schedule = @"预约成功";
        }
            break;
        case 2:
        {
            schedule = @"商家未接受";
        }
            break;
        case 3:
        {
            schedule = @"业务进行中";
        }
            break;
        case 4:
        {
            schedule   = @"预约已取消";
        }
            break;
        case 5:
        case 6:
        {
            schedule   = @"已完成";
        }
            break;
        default:
        {
            schedule = @"商家确认中";
        }
            break;
    }
    return schedule;
}

#pragma mark - Public Methods
- (BOOL)canShowResult
{
    return [_status isEqualToString:@"免费检测"];
}

- (BOOL)isAppraised
{
    return _comment.detail.length ? YES : NO;
}

- (SCOderType)oderType
{
    if ([_status isEqualToString:@"已完成"])
    {
        if ([self canShowResult])
            return [self isAppraised] ? SCOderTypeAppraisedCheck : SCOderTypeUnAppraisalCheck;
        else
            return [self isAppraised] ? SCOderTypeAppraised : SCOderTypeUnAppraisal;
    }
    else
        return SCOderTypeNormal;
}

@end
