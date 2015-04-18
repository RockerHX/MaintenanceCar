//
//  SCBuyGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCBuyGroupProductCell.h"
#import "SCGroupProductDetail.h"
#import "UIConstants.h"

@implementation SCBuyGroupProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _bugProductButton.layer.cornerRadius = 5.0f;
    self.productNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 100.0f;
}

#pragma mark - Action Methods
- (IBAction)bugProductButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldShowBuyProductView)])
        [_delegate shouldShowBuyProductView];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCGroupProductDetail *)detail
{
    self.productNameLabel.text  = detail.title;
    self.groupPriceLabel.text   = detail.final_price;
    self.productPriceLabel.text = detail.total_price;
    
    _bugProductButton.enabled = [detail canBug];
    [_bugProductButton setTitle:[detail canBug] ? @"抢购" : @"已抢光" forState:UIControlStateNormal];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
