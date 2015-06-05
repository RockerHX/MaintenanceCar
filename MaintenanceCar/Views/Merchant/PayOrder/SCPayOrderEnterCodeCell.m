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

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    CGFloat width = SELF_WIDTH;
    CGFloat height = SELF_HEIGHT;
    UIBezierPath *path = [self shadowPathWithPoints:@[@[@(ZERO_POINT), @(ZERO_POINT)],
                                                      @[@(ZERO_POINT), @(height)],
                                                      @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width), @(height + SHADOW_OFFSET*4)],
                                                      @[@(width), @(ZERO_POINT)]]];
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

#pragma mark - Public Methods
- (void)displayCellWithPaySucceed:(BOOL)paySucceed
{
    _enterCodeButton.enabled = !paySucceed;
}

@end
