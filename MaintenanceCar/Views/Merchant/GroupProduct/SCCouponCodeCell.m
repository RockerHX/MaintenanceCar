//
//  SCCouponCodeCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCodeCell.h"
#import "SCCoupon.h"

@implementation SCCouponCodeCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _reservationButton.layer.cornerRadius = 3.0f;
    _reservationButton.layer.borderWidth  = 1.0f;
    _reservationButton.layer.borderColor  = [UIColor orangeColor].CGColor;
}

#pragma mark - Action Methods
- (IBAction)reservationButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(couponShouldReservationWithIndex:)])
        [_delegate couponShouldReservationWithIndex:_index];
}

#pragma mark - Public Methods
- (void)displayCellWithCoupon:(SCCoupon *)coupon
{
    _codeLabel.text = coupon.code;
    _reservationButton.hidden = [coupon expired] || (coupon.state != SCCouponStateUnUse);
}

@end
