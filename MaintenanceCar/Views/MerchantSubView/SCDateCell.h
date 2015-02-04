//
//  SCDateCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDateCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet            UILabel *dayLabel;              // 天数栏
@property (weak, nonatomic) IBOutlet            UILabel *weekLabel;             // 星期栏

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;  // label宽度约束值

/**
 *  刷新Cell方法
 *
 *  @param date     日期
 *  @param constant label宽度约束值
 */
- (void)diplayWithDate:(NSString *)date constant:(CGFloat)constant;

@end
