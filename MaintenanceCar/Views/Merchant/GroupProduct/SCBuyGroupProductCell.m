//
//  SCBuyGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCBuyGroupProductCell.h"
#import "UIConstants.h"

@implementation SCBuyGroupProductCell
{
    BOOL _canReserve;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _bugProductButton.layer.cornerRadius = 5.0f;
    self.productNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 100.0f;
}

#pragma mark - Action Methods
- (IBAction)bugProductButtonPressed:(id)sender
{
    if (_canReserve)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldReserveProduct)])
            [_delegate shouldReserveProduct];
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(shouldShowBuyProductView)])
            [_delegate shouldShowBuyProductView];
    }
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCGroupProductDetail *)detail
{
    self.productNameLabel.text = detail.title;
    self.priceBeginLabel.text       = detail.final_price;
    self.totalPriceLabel.text  = detail.total_price;

    _bugProductButton.enabled  = [detail canBug];
    [_bugProductButton setTitle:[detail canBug] ? @"抢购" : @"已抢光" forState:UIControlStateNormal];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

- (void)displayCellWithPrice:(SCQuotedPrice *)price
{
    _canReserve = YES;
    BOOL hidden = NO;
    if ([price.price_begin integerValue] && [price.price_end integerValue])
    {
        hidden = YES;
        self.priceIntervalLabel.hidden = !hidden;
        self.priceEndLabel.hidden      = !hidden;
        self.priceBeginLabel.text      = price.price_begin;
        self.priceEndLabel.text        = price.price_end;
    }
    else
    {
        hidden = [price.final_price isEqualToString:price.total_price];
        self.priceBeginLabel.text  = price.final_price;
        self.totalPriceLabel.text  = price.total_price;
    }
    
    self.leftParenthesis.hidden  = hidden;
    self.totalPriceLabel.hidden  = hidden;
    self.rightParenthesis.hidden = hidden;
    self.grayLine.hidden         = hidden;
    self.productNameLabel.text   = price.title;
    [_bugProductButton setTitle:@"预约" forState:UIControlStateNormal];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

@end
