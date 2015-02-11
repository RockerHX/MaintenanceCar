//
//  SCDatePickerView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCDatePickerViewDelegate <NSObject>

@optional
/**
 *  时间选择器选择结束
 *
 *  @param date 选择的时间数据
 *  @param mode 选择器的类型
 */
- (void)datePickerSelectedFinish:(NSDate *)date mode:(UIDatePickerMode)mode;

@end

@interface SCDatePickerView : UIView

@property (nonatomic, weak) id<SCDatePickerViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIDatePicker       *datePicker;        // 时间选择器
@property (weak, nonatomic) IBOutlet UIView             *containerView;     // 容器View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // 时间选择器到View下边距约束条件

/**
 *  时间选择器View初始化方法
 *
 *  @param delegate 代理对象
 *  @param mode     选择器类型
 *
 *  @return SCDatePickerView实例对象
 */
- (id)initWithDelegate:(id<SCDatePickerViewDelegate>)delegate mode:(UIDatePickerMode)mode;

/**
 *  显示时间选择器 - 带动画
 */
- (void)show;

@end
