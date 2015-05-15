//
//  SCCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCell.h"

@implementation SCCouponCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _promptLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 56.0f;
}

- (CGFloat)displayCellWithCoupon:(SCCoupon *)coupon
{
    _titleLabel.text     = coupon.title;
    _amountLabel.text    = coupon.amount;
    _promptLabel.text    = coupon.prompt;
    _validDateLabel.text = coupon.validDate;
    return [self layoutSizeFittingSize];
}

@end
