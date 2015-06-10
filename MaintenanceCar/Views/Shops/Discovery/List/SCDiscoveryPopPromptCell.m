//
//  SCDiscoveryPopPromptCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryPopPromptCell.h"
#import "SCDiscoveryCellConstants.h"

@implementation SCDiscoveryPopPromptCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x + POP_CELL_OFFSET;
    frame.origin.y = frame.origin.y - CELL_OFFSET;
    frame.size.width = frame.size.width - POP_CELL_OFFSET*2;
    frame.size.height = frame.size.height + CELL_OFFSET;
    [super setFrame:frame];
}

#pragma mark - Draw Methods
#define CurveOffsetPointX   POP_CELL_DISPLACEMENT*0.75
- (void)drawRect:(CGRect)rect
{
    CGFloat  width = rect.size.width;
    CGFloat  height = rect.size.height;
    UIColor *color = [UIColor whiteColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(ZERO_POINT, ZERO_POINT)];
    [path addCurveToPoint:CGPointMake(POP_CELL_DISPLACEMENT, height) controlPoint1:CGPointMake(CurveOffsetPointX, height*0.25) controlPoint2:CGPointMake(POP_CELL_DISPLACEMENT/4, height)];
    [path addLineToPoint:CGPointMake(width - POP_CELL_DISPLACEMENT, height)];
    [path addCurveToPoint:CGPointMake(width, ZERO_POINT) controlPoint1:CGPointMake(width - POP_CELL_DISPLACEMENT/4, height) controlPoint2:CGPointMake(width - CurveOffsetPointX, height*0.25)];
    [color setStroke];
    [color setFill];
    [path fill];
    [path stroke];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(ZERO_POINT, SHADOW_OFFSET);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 1.0f;
    
    if (!_topLeftShadowLayer)
    {
        _topLeftShadowLayer = [CALayer layer];
        _topLeftShadowLayer.frame = CGRectMake(-POP_CELL_OFFSET + 10.0f, ZERO_POINT, POP_CELL_OFFSET*0.75, SHADOW_OFFSET);
        _topLeftShadowLayer.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.8f].CGColor;
        [self.layer addSublayer:_topLeftShadowLayer];
    }
    if (!_topRightShadowLayer)
    {
        _topRightShadowLayer = [CALayer layer];
        _topRightShadowLayer.frame = CGRectMake(SELF_WIDTH, ZERO_POINT, POP_CELL_OFFSET*0.75, SHADOW_OFFSET);
        _topRightShadowLayer.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.8f].CGColor;
        [self.layer addSublayer:_topRightShadowLayer];
    }
}

@end
