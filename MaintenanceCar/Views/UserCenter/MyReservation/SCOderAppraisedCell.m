//
//  SCOderAppraisedCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderAppraisedCell.h"
#import "SCReservation.h"

@implementation SCOderAppraisedCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _appraisalLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 16.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithReservation:(SCReservation *)reservation
{
    [super displayCellWithReservation:reservation];
    
    _appraisalLabel.text = reservation.comment.detail;
}

@end
