//
//  SCOderAppraisedCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderAppraisedCell.h"
#import "SCStarView.h"

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
    
    _startView.value     = [@([reservation.comment.star integerValue]/2) stringValue];
    _appraisalLabel.text = reservation.comment.detail;
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

@end
