//
//  SCBugGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCBugGroupProductCell.h"
#import "SCGroupProductDetail.h"
#import "SCCouponDetail.h"

@implementation SCBugGroupProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _buyButton.layer.cornerRadius = 4.0f;
}

#pragma mark - Action Methods
- (IBAction)bugProductButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldShowBuyProductView)])
        [_delegate shouldShowBuyProductView];
}

#pragma mark - Public Methods
- (void)displayCellWithProductDetial:(SCGroupProductDetail *)detail
{
    self.productNameLabel.text  = detail.title;
    self.groupPriceLabel.text   = detail.final_price;
    self.productPriceLabel.text = detail.total_price;
}

- (void)displayCellWithCouponDetial:(SCCouponDetail *)detail
{
    self.productNameLabel.text  = detail.title;
    self.groupPriceLabel.text   = detail.final_price;
    self.productPriceLabel.text = detail.total_price;
}

@end
