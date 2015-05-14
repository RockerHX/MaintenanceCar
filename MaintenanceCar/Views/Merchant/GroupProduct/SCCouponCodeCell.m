//
//  SCCouponCodeCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCodeCell.h"

@implementation SCCouponCodeCell
{
    SCGroupCoupon *_coupon;
}

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
    if (_coupon.state == SCGroupCouponStateUnUse)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(couponShouldReservationWithIndex:)])
            [_delegate couponShouldReservationWithIndex:self.tag];
    }
    else if (_coupon.state == SCGroupCouponStateReserved)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(couponShouldShowWithIndex:)])
            [_delegate couponShouldShowWithIndex:self.tag];
    }
}

#pragma mark - Public Methods
- (void)displayCellWithCoupon:(SCGroupCoupon *)coupon index:(NSInteger)index
{
    self.tag = index;
    _coupon = coupon;
    _codeLabel.text = coupon.code;
    
    BOOL hidden = NO;
    switch (coupon.state)
    {
        case SCGroupCouponStateUnUse:
        case SCGroupCouponStateReserved:
            break;
            
        default:
            hidden = YES;
            break;
    }
    _reservationButton.hidden = [coupon expired] || hidden;
    
    NSString *buttonTitle = nil;
    if (coupon.state == SCGroupCouponStateReserved)
    {
        buttonTitle = @"查看预约";
        _reservationButtonWidith.constant = 70.0f;
    }
    else if (coupon.state == SCGroupCouponStateUnUse)
        buttonTitle = @"预约";
    [_reservationButton setTitle:buttonTitle forState:UIControlStateNormal];
}

@end
