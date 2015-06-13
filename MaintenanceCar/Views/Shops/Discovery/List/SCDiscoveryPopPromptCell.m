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
    
    self.layer.shadowColor = [UIColor colorWithWhite:0.8f alpha:0.9f].CGColor;
    self.layer.shadowOffset = CGSizeMake(ZERO_POINT, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

#pragma mark - Public Methods
- (void)displayCellWithPrompt:(NSString *)prompt openUp:(BOOL)openUp
{
    _promptLabel.text = prompt;
    _arrowIcon.transform = openUp ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
}

@end
