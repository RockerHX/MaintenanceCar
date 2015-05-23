//
//  SCPayOderGroupProductSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderGroupProductSummaryCell.h"

@implementation SCPayOderGroupProductSummaryCell
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
    double totalPrice = (_productCount * _productPrice);
    _countLabel.text = @(_productCount).stringValue;
    _priceLabel.text = [NSString stringWithFormat:@"%.2f", totalPrice];
    return totalPrice;
}

#pragma mark - Publi Methods
- (CGFloat)displayCellWithProduct:(SCGroupProduct *)product
{
    _productPrice               = [product.final_price doubleValue];
    self.serviceNameLabel.text  = product.title;
    self.merchantNameLabel.text = product.merchantName;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didDisplayProductPrice:)])
        [_delegate didDisplayProductPrice:[self getTotalPriceAndDisplayView]];
    
    return [self layoutSizeFittingSize];
}

@end
