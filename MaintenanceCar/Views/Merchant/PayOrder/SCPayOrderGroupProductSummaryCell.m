//
//  SCPayOrderGroupProductSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOrderGroupProductSummaryCell.h"

@implementation SCPayOrderGroupProductSummaryCell
{
    NSInteger _productCount;
    double    _productPrice;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initConfig];
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 43.0f;
    _countLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _countLabel.layer.borderWidth = 1.0f;
    _cutButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _cutButton.layer.borderWidth = 1.0f;
    _addButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addButton.layer.borderWidth = 1.0f;
}

#pragma mark - Config Methods
- (void)initConfig
{
    _productCount = 1;
}

#pragma mark - Action Methods
- (IBAction)cutButtonPressed
{
    _productCount = _productCount - 1;
    if (_productCount < 1)
        _productCount = 1;
    if (_delegate && [_delegate respondsToSelector:@selector(didConfirmProductPrice:purchaseCount:)])
        [_delegate didConfirmProductPrice:[self getTotalPriceAndDisplayView] purchaseCount:_productCount];
}

- (IBAction)addButtonPressed
{
    _productCount = _productCount + 1;
    if (_delegate && [_delegate respondsToSelector:@selector(didConfirmProductPrice:purchaseCount:)])
        [_delegate didConfirmProductPrice:[self getTotalPriceAndDisplayView] purchaseCount:_productCount];
}

#pragma mark - Private Methods
- (double)getTotalPriceAndDisplayView
{
    _countLabel.text = @(_productCount).stringValue;
    _priceLabel.text = [NSString stringWithFormat:@"%.2f", (_productCount * _productPrice)];
    return _productPrice;
}

#pragma mark - Publi Methods
- (void)displayCellWithProduct:(SCGroupProduct *)product
{
    self.serviceNameLabel.text  = product.title;
    self.merchantNameLabel.text = product.name;
    
    _productPrice          = [product.final_price doubleValue];
    _paySuccessView.hidden = !product.tickets.count;
    _payCountLabel.text    = @(product.tickets.count).stringValue;
    [self getTotalPriceAndDisplayView];
}

@end
