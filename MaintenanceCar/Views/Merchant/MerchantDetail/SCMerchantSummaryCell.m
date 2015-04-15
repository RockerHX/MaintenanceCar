//
//  SCMerchantSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantSummaryCell.h"
#import "VersionConstants.h"
#import "UIConstants.h"
#import "SCStarView.h"

@implementation SCMerchantSummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    self.separatorInset = UIEdgeInsetsMake(ZERO_POINT, ZERO_POINT, ZERO_POINT, SCREEN_WIDTH - 16.0f);
    // 绘制圆角
    _reservationButton.layer.cornerRadius = 6.0f;
    _merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 23.0f;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldNormalReservation)])
        [_delegate shouldNormalReservation];
}

#pragma mark - Public Methods
- (void)displayCellWithSummary:(SCMerchantSummary *)detailSummary
{
    _merchantNameLabel.text     = detailSummary.name;
    _distanceLabel.text         = detailSummary.distance;
    _starView.value             = detailSummary.star;
    _reservationButton.hidden   = detailSummary.unReserve;
    _commentView.hidden         = detailSummary.have_comment;
    _commentViewHeight.constant = detailSummary.have_comment ? Zero : _commentViewHeight.constant;
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
