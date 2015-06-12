//
//  SCDiscoveryPopProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryPopProductCell.h"
#import "SCDiscoveryCellConstants.h"
#import "SCShop.h"

@implementation SCDiscoveryPopProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x + CELL_OFFSET;
    frame.origin.y = frame.origin.y - CELL_OFFSET;
    frame.size.width = frame.size.width - CELL_OFFSET*2;
    frame.size.height = frame.size.height + CELL_OFFSET;
    [super setFrame:frame];
}

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    self.layer.shadowColor = [UIColor colorWithWhite:0.8f alpha:0.9f].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius  = 1.0f;
}

#pragma mark - Public Methods
static int firstRow = 1;
- (void)displayCellWithProduct:(SCShopProduct *)product index:(NSInteger)index
{
    CGFloat  width                = SELF_WIDTH;
    CGFloat  height               = SELF_HEIGHT;
    CGFloat  topShadowHeight      = ZERO_POINT;
    NSArray *cellShadowPathPoints = @[@[@(ZERO_POINT), @(ZERO_POINT)],
                                      @[@(ZERO_POINT), @(height)],
                                      @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                      @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                      @[@(width), @(height)],
                                      @[@(width), @(ZERO_POINT)],
                                      @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                      @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]];;
    
    if (index == firstRow)
        topShadowHeight = SHADOW_OFFSET*10;
    
    self.layer.shadowPath = [self shadowPathWithPoints:cellShadowPathPoints].CGPath;
    
    if (!_shadowLayer)
    {
        _shadowLayer = [CAGradientLayer layer];
        _shadowLayer.startPoint = CGPointMake(SHADOW_OFFSET, ZERO_POINT);
        _shadowLayer.endPoint = CGPointMake(SHADOW_OFFSET, SHADOW_OFFSET*2);
        _shadowLayer.colors = @[(id)[UIColor colorWithWhite:0.8f alpha:0.9f].CGColor,
                                (id)self.backgroundColor.CGColor];
        _shadowLayer.locations = @[@(0.1f)];
        [self.layer addSublayer:_shadowLayer];
    }
    _shadowLayer.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SELF_WIDTH, topShadowHeight);
    
    _hotIcon.hidden = !product.hot;
    _productNameLabel.text = product.title;
    _discountPriceLabel.text = product.discountPrice;
}

@end
