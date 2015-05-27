//
//  SCPayOrderCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOrderCouponCell.h"

@implementation SCPayOrderCouponCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    _couponPromptLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 71.0f;
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.y = frame.origin.y - 10.0f;
    frame.size.height = frame.size.height + 10.0f;
    [super setFrame:frame];
}

#pragma mark - Action Methods
- (IBAction)checkBoxButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(payOrderCouponCell:)])
        [_delegate payOrderCouponCell:self];
}

#pragma mark - Public Methods
- (void)displayCellWithCoupons:(NSArray *)coupons index:(NSInteger)index couponCode:(NSString *)couponCode
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(ZERO_POINT, -SHADOW_OFFSET*4)];
    [path addLineToPoint:CGPointMake(ZERO_POINT, SELF_HEIGHT)];
    [path addLineToPoint:CGPointMake(SHADOW_OFFSET*2, SELF_HEIGHT - SHADOW_OFFSET*6)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH - SHADOW_OFFSET*2, SELF_HEIGHT - SHADOW_OFFSET*6)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH, SELF_HEIGHT + SHADOW_OFFSET*4)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH, -SHADOW_OFFSET*4)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH - SHADOW_OFFSET*2, SHADOW_OFFSET*6)];
    [path addLineToPoint:CGPointMake(SHADOW_OFFSET*2, SHADOW_OFFSET*6)];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
    
    self.tag = index;
    SCCoupon *coupon = coupons[index];
    _checkBoxButton.selected = [coupon.code isEqualToString:couponCode];
    if (index == (coupons.count - 1))
        self.layer.shadowPath = nil;
    
    _couponPromptLabel.text = coupon.title;
}

@end
