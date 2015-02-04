//
//  SCSelectedCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSelectedCell.h"

@implementation SCSelectedCell

#pragma mark - Setter And Getter Methods
- (void)setShowTopLine:(BOOL)showTopLine
{
    _showTopLine    = showTopLine;
    _topLine.hidden = !showTopLine;
}

#pragma mark - Public Methods
- (void)displayItemWithContents:(NSDictionary *)contents indexPath:(NSIndexPath *)indexPath constant:(CGFloat)constant
{
    if (contents)
    {
        // 升序处理
        NSArray *keys = [[contents allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        NSString *key = keys[indexPath.row];
        // 设置内容显示
        if (indexPath.row)
            _textLabel.text = contents[key];
        
        [self displayWithConstant:constant];
    }
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
}

- (void)displayItemWithTimes:(NSArray *)times section:(NSInteger)section constant:(CGFloat)constant
{
    if (times)
    {
        // 升序处理
        times = [times sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        _textLabel.text = [times[section] substringWithRange:(NSRange){0, 2}];
        
        [self displayWithConstant:constant];
    }
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Private Methos
/**
 *  通过约束值刷新label宽度
 *
 *  @param constant 约束值
 */
-  (void)displayWithConstant:(CGFloat)constant
{
    // 更新约束，保证label正确显示
    _topLineWidthConstraint.constant    = constant;
    _bottomLineWidthConstraint.constant = constant;
    _textLabelWidthConstraint.constant  = constant;
    
    [_topLine needsUpdateConstraints];
    [_topLine layoutIfNeeded];
    [_bottomLine needsUpdateConstraints];
    [_bottomLine layoutIfNeeded];
    [_textLabel needsUpdateConstraints];
    [_textLabel layoutIfNeeded];
}

@end
