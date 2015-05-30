//
//  SCOrderDetailPayCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailPayCell.h"
#import "SCOrderDetail.h"

@implementation SCOrderDetailPayCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _descriptionLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 128.0f;
}

#pragma mark - Action Methods
- (IBAction)payOrderButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userWantToPayForOrder)])
        [_delegate userWantToPayForOrder];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOrderDetail *)detail
{
//    if (detail.isPay)
//    {
//        _promptLabel.text = @"已支付";
//        _payOrderButton.hidden = YES;
//    }
//    else
//    {
//        _promptLabel.text = @"预估价格";
//        _payOrderButton.hidden = NO;
//    }
    _priceLabel.text = detail.price;
}

@end
