//
//  SCGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"
#import "SCGroupProduct.h"
#import "UIConstants.h"

@implementation SCGroupProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _productNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 70.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithProduct:(SCGroupProduct *)product
{
    BOOL hidden              = [product.final_price isEqualToString:product.total_price];
    _leftParenthesis.hidden  = hidden;
    _totalPriceLabel.hidden  = hidden;
    _rightParenthesis.hidden = hidden;
    _grayLine.hidden         = hidden;

    _productNameLabel.text   = product.title;
    _priceBeginLabel.text    = product.final_price;
    _totalPriceLabel.text    = product.total_price;
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
