//
//  SCPayOderResultCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderResultCell.h"

@implementation SCPayOderResultCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _weiXinPayButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _weiXinPayButton.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _weiXinPayButton.layer.shadowOpacity = 1.0f;
    _weiXinPayButton.layer.shadowRadius = 1.0f;
    
    _aliPayButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _aliPayButton.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _aliPayButton.layer.shadowOpacity = 1.0f;
    _aliPayButton.layer.shadowRadius = 1.0f;
}

#pragma mark - Action Methods
- (IBAction)weiXinPayBUttonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldPayForOderWithPayment:)])
        [_delegate shouldPayForOderWithPayment:SCPayOdermentWeiXinPay];
}

- (IBAction)aliPayButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldPayForOderWithPayment:)])
        [_delegate shouldPayForOderWithPayment:SCPayOdermentAliPay];
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithResult:(SCPayOderResult *)result
{
    _totalPriceLabel.text      = result.totalPrice;
    _deductiblePriceLabel.text = result.deductiblePrice;
    _payPriceLabel.text        = result.payPrice;
    
    return 154.0f;
}

@end
