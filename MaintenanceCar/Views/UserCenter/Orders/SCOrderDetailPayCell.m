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

#pragma mark - Action Methods
- (IBAction)payOrderButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userWantToPayForOrder)])
        [_delegate userWantToPayForOrder];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOrderDetail *)detail
{
    _priceLabel.text = detail.price;
}

@end
