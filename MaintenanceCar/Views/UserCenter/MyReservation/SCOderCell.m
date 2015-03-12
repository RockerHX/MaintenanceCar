//
//  SCOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"
#import "SCReservation.h"

@implementation SCOderCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 69.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithReservation:(SCReservation *)reservation
{
    _merchantNameLabel.text    = reservation.name;
    _reservationTypeLabel.text = reservation.type;
    _scheduleLabel.text        = reservation.status;
    _reservationDateLabel.text = reservation.reserve_time;
    _carInfoLabel.text         = reservation.car_model_name;
    
    _scheduleLabel.textColor = ([reservation.status isEqualToString:@"预约已取消"] || [reservation.status isEqualToString:@"已完成"]) ? [UIColor redColor] : [UIColor grayColor];
}

#pragma mark - Private Methods

@end
