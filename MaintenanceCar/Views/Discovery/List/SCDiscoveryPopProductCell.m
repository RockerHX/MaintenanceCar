//
//  SCDiscoveryPopProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryPopProductCell.h"
#import "SCDiscoveryCellConstants.h"
#import "MicroConstants.h"

@implementation SCDiscoveryPopProductCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x + CELL_OFFSET;
    frame.origin.y = frame.origin.y - CELL_OFFSET;
    frame.size.width = frame.size.width - CELL_OFFSET*2;
    frame.size.height = frame.size.height + CELL_OFFSET;
    [super setFrame:frame];
}

#pragma mark - Public Methods
#define FirstProductRow     1
- (void)displayCellWithProducts:(NSArray *)products index:(NSInteger)index
{
    CGFloat  width                = SELF_WIDTH;
    CGFloat  height               = SELF_HEIGHT;
    CGFloat  topShadowHeight      = SHADOW_OFFSET*4;
    NSArray *cellShadowPathPoints = nil;
    if (index == FirstProductRow)
    {
        cellShadowPathPoints = @[@[@(ZERO_POINT), @(ZERO_POINT)],
                                 @[@(ZERO_POINT), @(height)],
                                 @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                 @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                 @[@(width), @(height)],
                                 @[@(width), @(ZERO_POINT)],
                                 @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                 @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]];
        topShadowHeight = SHADOW_OFFSET*14;
    }
    else if (index == products.count)
    {
        cellShadowPathPoints = @[@[@(ZERO_POINT), @(ZERO_POINT)],
                                 @[@(ZERO_POINT), @(height)],
                                 @[@(POP_CELL_OFFSET - CELL_OFFSET), @(height)],
                                 @[@(POP_CELL_OFFSET - CELL_OFFSET), @(height - SHADOW_OFFSET*6)],
                                 @[@(width - (POP_CELL_OFFSET - CELL_OFFSET)), @(height - SHADOW_OFFSET*6)],
                                 @[@(width - (POP_CELL_OFFSET - CELL_OFFSET)), @(height)],
                                 @[@(width), @(height)],
                                 @[@(width), @(ZERO_POINT)],
                                 @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                 @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]];
    }
    else
    {
        cellShadowPathPoints = @[@[@(ZERO_POINT), @(ZERO_POINT)],
                                 @[@(ZERO_POINT), @(height)],
                                 @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                 @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                 @[@(width), @(height)],
                                 @[@(width), @(ZERO_POINT)],
                                 @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                 @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]];
    }
    self.layer.shadowPath    = [self shadowPathWithPoints:cellShadowPathPoints].CGPath;
    self.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset  = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius  = 1.0f;

    if (!shadowLayer)
    {
        shadowLayer = [CAGradientLayer layer];
        shadowLayer.startPoint = CGPointMake(SHADOW_OFFSET, ZERO_POINT);
        shadowLayer.endPoint = CGPointMake(SHADOW_OFFSET, SHADOW_OFFSET*2);
        shadowLayer.colors = @[(id)[UIColor colorWithWhite:0.85f alpha:0.9f].CGColor,
                               (id)self.backgroundColor.CGColor];
        shadowLayer.locations = @[@(0.1f)];
        [self.layer addSublayer:shadowLayer];
    }
    shadowLayer.frame = CGRectMake(ZERO_POINT, ZERO_POINT, width, topShadowHeight);
}

@end
