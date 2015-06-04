//
//  SCCollectionIndexView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/12.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewCategory.h"

@interface SCCollectionIndexView : UIControl

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;   // 索引View到父视图右边距的约束条件

@property (strong, nonatomic)        NSArray            *indexTitles;       // 索引标题数据集合
@property (readonly, nonatomic)      NSInteger          selectedIndex;      // 索引标记

/**
 *  SCCollectionIndexView初始化方法
 *
 *  @param frame       view显示框架参数
 *  @param indexTitles 索引标题数据
 *
 *  @return SCCollectionIndexView实例
 */
- (id)initWithFrame:(CGRect)frame indexTitles:(NSArray *)indexTitles;

/**
 *  选择索引标题
 *
 *  @return 被选择的标题
 */
- (NSString *)selectedIndexTitle;

/**
 *  显示SCCollectionIndexView
 *
 *  @param animation 是否带动画
 */
- (void)showWithAnimation:(BOOL)animation;

/**
 *  隐藏SCCollectionIndexView
 *
 *  @param animation 是否带动画
 */
- (void)hiddenWithAnimation:(BOOL)animation;

@end
