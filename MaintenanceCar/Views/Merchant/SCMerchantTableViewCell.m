//
//  SCMerchantTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantTableViewCell.h"
#import "MicroCommon.h"

@implementation SCMerchantTableViewCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _reservationButton.layer.cornerRadius = 5.0f;
    
    if (IS_IPHONE_5_PRIOR)
    {
        if (IS_IOS8)
            [self performSelector:@selector(viewConfig) withObject:nil afterDelay:0.1f];
        else
            [self viewConfig];
    }
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldReservationWithIndex:)])
        [_delegate shouldReservationWithIndex:_index];
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _buttonWidth.constant = 66.0f;
    [_reservationButton needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_reservationButton layoutIfNeeded];
    }];
}

@end
