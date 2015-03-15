//
//  SCGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"
#import "SCGroupProduct.h"

@implementation SCGroupProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // Initialization code
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
}

@end
