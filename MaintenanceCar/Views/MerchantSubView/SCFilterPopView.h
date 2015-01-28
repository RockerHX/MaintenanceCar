//
//  SCFilterPopView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCFilterPopViewDelegate <NSObject>

@optional
// 收回筛选条件View的代理方法，用户点击黑色透明部分或者选择筛选条件之后
- (void)shouldClosePopView;

@end

@interface SCFilterPopView : UIView

@property (nonatomic, weak)                          id <SCFilterPopViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet             UIView *contentView;                       // 筛选条件的展示View
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;       // 筛选条件的展示View(contentView)到父视图(SCFilterPopView)底部的约束条件

/**
 *  展示筛选条件View - 带动画
 */
- (void)showContentView;

@end
