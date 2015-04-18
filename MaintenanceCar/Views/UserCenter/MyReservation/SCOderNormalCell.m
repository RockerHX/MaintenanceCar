//
//  SCOderNormalCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/13.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderNormalCell.h"

@implementation SCOderNormalCell

#pragma mark - Public Methods
- (void)displayCellWithReservation:(SCReservation *)reservation
{
    [super displayCellWithReservation:reservation];
    
    _reservationDateLabel.text = reservation.reserve_time;
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
