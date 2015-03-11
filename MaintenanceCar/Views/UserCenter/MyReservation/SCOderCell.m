//
//  SCOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"
#import "MicroCommon.h"
#import "SCReservation.h"

@implementation SCOderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 170.0f;
}

#pragma mark - Public Methods
+ (BOOL)canShowMore:(NSString *)status
{
    return [status isEqualToString:@"免费检测"];
}

- (void)displayCellWithReservation:(SCReservation *)reservation
{
    _merchantNameLabel.text    = reservation.name;
    _reservationTypeLabel.text = reservation.type;
    _scheduleLabel.text        = [self handleMaintenanceSchedule:reservation.status];
    _reservationDateLabel.text = reservation.reserve_time;
    _carInfoLabel.text         = reservation.car_model_name;
}

#pragma mark - Private Methods
- (NSString *)handleMaintenanceSchedule:(NSString *)status
{
    NSInteger state = [status integerValue];
    switch(state)
    {
        case 1:
            return @"预约成功";
            break;
        case 2:
            return @"商家未接受";
            break;
        case 3:
            return @"业务进行中";
            break;
        case 4:
            return @"预约已取消";
            break;
        case 5:
            return @"已完成";
            break;
        case 6:
            return @"检测已完成";
            break;
        default:
            return @"商家确认中";
            break;
    }
}

@end
