//
//  SCOderDetailPayCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderDetailPayCell.h"
#import "SCOderDetail.h"

@implementation SCOderDetailPayCell

#pragma mark - Action Methods
- (IBAction)payOderButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userWantToPayForOder)])
        [_delegate userWantToPayForOder];
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOderDetail *)detail
{
    _priceLabel.text = detail.price;
}

@end
