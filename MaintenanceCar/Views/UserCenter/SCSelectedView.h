//
//  SCSelectedView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSelectedView : UIView

@property (nonatomic, assign)                      BOOL canSelected;                // View是否能被选中

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;       // 到父视图上边距约束条件
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;    // 到父视图下边距约束条件

@property (weak, nonatomic) IBOutlet             UIView *titleView;                 // 展示给用户的标题View，用户点击此栏会触发显示货关闭当前View事件
@property (weak, nonatomic) IBOutlet        UIImageView *arrowIcon;                 // 箭头图标

/**
 *  需要显示视图，执行此方法
 */
- (void)selected;

/**
 *  刷新箭头图标
 */
- (void)updateArrowIcon;

- (void)titleColumnTaped;

@end
