//
//  SCGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"
#import "SCGroupProduct.h"
#import "MicroCommon.h"

@implementation SCGroupProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _productNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 70.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithProduct:(SCGroupProduct *)product
{
    if (product)
    {
        _productNameLabel.text  = product.title;
        _groupPriceLabel.text   = product.final_price;
        _productPriceLabel.text = product.total_price;
    }
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
