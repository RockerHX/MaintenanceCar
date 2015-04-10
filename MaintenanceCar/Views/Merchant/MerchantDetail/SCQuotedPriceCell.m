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
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSpecialReservation)])
        [_delegate shouldSpecialReservation];
}

#pragma mark - Public Methods
- (void)displayCellWithProduct:(SCQuotedPrice *)product
{
    _nameLabel.text       = product.title;
    _priceLabel.text      = product.final_price;
    _totalPriceLabel.text = product.total_price;
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
