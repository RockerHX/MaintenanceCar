//
//  SCCouponDetailRuleCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponDetailRuleCell.h"
#import "SCCoupon.h"

@implementation SCCouponDetailRuleCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _ruleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 20.0f;
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithCoupon:(SCCoupon *)coupon
{
    _ruleLabel.text = coupon.memo;
    return [self layoutSizeFittingSize];
}

@end
