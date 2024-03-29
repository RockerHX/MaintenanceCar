//
//  SCQuotedPriceCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCQuotedPriceCell.h"
#import "SCQuotedPrice.h"
#import "UIConstants.h"

@implementation SCQuotedPriceCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 绘制圆角
    _reservationButton.layer.cornerRadius = 3.0f;
    _nameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 23.0f;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSpecialReservationWithIndex:)])
        [_delegate shouldSpecialReservationWithIndex:self.tag];
}

#pragma mark - Public Methods
- (void)displayCellWithPrice:(SCQuotedPrice *)price
{
    BOOL hidden              = [price.final_price isEqualToString:price.total_price];
    _leftParenthesis.hidden  = hidden;
    _totalPriceLabel.hidden  = hidden;
    _rightParenthesis.hidden = hidden;
    _grayLine.hidden         = hidden;

    _nameLabel.text          = price.title;
    _promptLabel.text        = hidden ? @"报价" : @"修养价";
    _priceLabel.text         = price.final_price;
    _totalPriceLabel.text    = price.total_price;
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
