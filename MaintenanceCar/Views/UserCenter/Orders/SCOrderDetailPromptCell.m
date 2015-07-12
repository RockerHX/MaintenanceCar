//
//  SCOrderDetailPromptCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailPromptCell.h"

@implementation SCOrderDetailPromptCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.size.height = frame.size.height + 10.0f;
    [super setFrame:frame];
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

@end
