//
//  SCSelectedCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSelectedCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet  UIView *topLine;
@property (weak, nonatomic) IBOutlet  UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLineWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelWidthConstraint;

@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL canSelected;

/**
 *  刷新预约数方法
 *
 *  @param contents  label内容集合
 *  @param indexPath 序列索引
 *  @param constant  label宽度约束值
 */
- (void)displayItemWithText:(NSNumber *)text canSelected:(BOOL)canSelected constant:(CGFloat)constant;

/**
 *  刷新时间方法
 *
 *  @param times  label内容集合
 *  @param section 序列索引
 *  @param constant  label宽度约束值
 */
- (void)displayItemWithTimes:(NSArray *)times section:(NSInteger)section constant:(CGFloat)constant;

@end
