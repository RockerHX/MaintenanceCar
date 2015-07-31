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
    frame.origin.x = frame.origin.x + PopCellOffset;
    frame.origin.y = frame.origin.y - CellOffset;
    frame.size.width = frame.size.width - PopCellOffset*2;
    frame.size.height = frame.size.height + CellOffset;
    [super setFrame:frame];
}

#pragma mark - Draw Methods
#define CurveOffsetPointX   PopCellDisplacment*0.75
- (void)drawRect:(CGRect)rect
{
    CGFloat  width = rect.size.width;
    CGFloat  height = rect.size.height;
    UIColor *color = [UIColor whiteColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(ZERO_POINT, ZERO_POINT)];
    [path addCurveToPoint:CGPointMake(PopCellDisplacment, height) controlPoint1:CGPointMake(CurveOffsetPointX, height*0.25) controlPoint2:CGPointMake(PopCellDisplacment/4, height)];
    [path addLineToPoint:CGPointMake(width - PopCellDisplacment, height)];
    [path addCurveToPoint:CGPointMake(width, ZERO_POINT) controlPoint1:CGPointMake(width - PopCellDisplacment/4, height) controlPoint2:CGPointMake(width - CurveOffsetPointX, height*0.25)];
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
- (void)displayCellWithPrompt:(NSString *)prompt openUp:(BOOL)openUp canPop:(BOOL)canPop
{
    _promptLabel.text = prompt;
    if (!canPop)
    {
        _arrowIcon.hidden = YES;
        _centerXConstraint.constant = Zero;
        return;
    }
    else
    {
        _centerXConstraint.constant = 5.0f;
        _arrowIcon.hidden = NO;
    }
    _arrowIcon.transform = openUp ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
}

@end
