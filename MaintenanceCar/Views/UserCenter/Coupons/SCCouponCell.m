//
//  SCCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCell.h"

@implementation SCCouponCell

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    _promptLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 56.0f;
}

#pragma mark - Setter And Getter Methods
- (void)setCanNotUse:(BOOL)canNotUse {
    _canNotUse = canNotUse;
    if (canNotUse) {
        _couponBgView.image = [_couponBgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_couponBgView setTintColor:[UIColor grayColor]];
    }
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithCoupon:(SCCoupon *)coupon {
    _titleLabel.text     = coupon.title;
    _symbolLabel.hidden  = !coupon.showSymbol;
    _amountLabel.text    = coupon.amountPrompt;
    _promptLabel.text    = coupon.prompt;
    _validDateLabel.text = coupon.validDate;
    return [self layoutSizeFittingSize];
}

@end
