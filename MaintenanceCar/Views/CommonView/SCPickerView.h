//
//  SCPickerView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAllDictionary.h"

@protocol SCPickerViewDelegate <NSObject>

@optional
/**
 *  选择器选择结束
 *
 *  @param item 筛选选项
 *  @param name 筛选显示名称
 */
- (void)pickerViewSelectedFinish:(SCServiceItem *)serviceItem;

@end

@interface SCPickerView : UIView

@property (nonatomic, weak) id<SCPickerViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIPickerView       *picker;            // 时间选择器
@property (weak, nonatomic) IBOutlet UIView             *containerView;     // 容器View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // 时间选择器到View下边距约束条件

/**
 *  选择器View初始化方法
 *
 *  @param delegate 代理对象
 *
 *  @return SCPickerView实例对象
 */
- (id)initWithDelegate:(id<SCPickerViewDelegate>)delegate;

/**
 *  显示选择器 - 带动画
 */
- (void)show;

@end
