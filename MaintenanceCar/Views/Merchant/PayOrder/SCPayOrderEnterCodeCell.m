//
//  SCPayOrderEnterCodeCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOrderEnterCodeCell.h"

@implementation SCPayOrderEnterCodeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _enterCodeButton.layer.borderColor  = _enterCodeButton.titleLabel.textColor.CGColor;
    _enterCodeButton.layer.borderWidth  = 0.5f;
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(ZERO_POINT, ZERO_POINT)];
    [path addLineToPoint:CGPointMake(ZERO_POINT, SELF_HEIGHT)];
    [path addLineToPoint:CGPointMake(SHADOW_OFFSET*2, SELF_HEIGHT - SHADOW_OFFSET*6)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH - SHADOW_OFFSET*2, SELF_HEIGHT - SHADOW_OFFSET*6)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH, SELF_HEIGHT + SHADOW_OFFSET*4)];
    [path addLineToPoint:CGPointMake(SELF_WIDTH, ZERO_POINT)];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

#pragma mark - Action Methods
- (IBAction)enterCodeButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldEnterCouponCode)])
        [_delegate shouldEnterCouponCode];
}

@end
