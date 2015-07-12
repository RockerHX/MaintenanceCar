//
//  SCTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@implementation SCTableViewCell

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    // V2卡片设计
    frame.origin.x = frame.origin.x + 10.0f;
    frame.origin.y = frame.origin.y + 10.0f;
    frame.size.width = frame.size.width - 20.0f;
    frame.size.height = frame.size.height - 10.0f;
    [super setFrame:frame];
}

#pragma mark - Public Methods
- (CGFloat)layoutSizeFittingSize
{
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 10.0f;
}

- (UIBezierPath *)shadowPathWithPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    points = [self pointsWithArray:points];
    CGPoint firstPoint = CGPointFromString([points firstObject]);
    [path moveToPoint:firstPoint];
    
    for (NSInteger index = 1; index < points.count; index ++)
    {
        CGPoint point = CGPointFromString(points[index]);
        [path addLineToPoint:point];
    }
    return path;
}

#pragma mark - Private Methods
- (NSString *)pointToStringWithX:(CGFloat)x y:(CGFloat)y
{
    CGPoint point = CGPointMake(x, y);
    return NSStringFromCGPoint(point);
}

- (NSArray *)pointsWithArray:(NSArray *)array
{
    NSMutableArray *points = @[].mutableCopy;
    __weak typeof(self)weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *pointData = obj;
        [points addObject:[weakSelf pointToStringWithX:((NSNumber *)[pointData firstObject]).doubleValue y:((NSNumber *)[pointData lastObject]).doubleValue]];
    }];
    return points;
}

@end
