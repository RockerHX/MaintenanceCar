//
//  SCPickerView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAllDictionary.h"
#import "SCUserInfo.h"

typedef NS_ENUM(NSInteger, SCPickerType) {
    SCPickerTypeDefault,
    SCPickerTypeCar,
    SCPickerTypeService,
    SCPickerTypeDate
};

@protocol SCPickerViewDelegate;

@interface SCPickerView : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet       UIPickerView *picker;            // 时间选择器
@property (weak, nonatomic) IBOutlet             UIView *containerView;     // 容器View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;  // 时间选择器到View下边距约束条件

@property (nonatomic, weak)                          id  <SCPickerViewDelegate>delegate;
@property (nonatomic, strong, readonly)         NSArray *pickerItmes;       // 选择器数据Cache
@property (nonatomic, assign, readonly)    SCPickerType type;               // 选择器类型

- (IBAction)enterButtonPressed:(id)sender;

/**
 *  选择器View初始化方法
 *
 *  @param delegate 代理对象
 *
 *  @return SCPickerView实例对象
 */
- (id)initWithItems:(NSArray *)items type:(SCPickerType)type delegate:(id<SCPickerViewDelegate>)delegate;

/**
 *  显示选择器 - 带动画
 */
- (void)show;
- (void)hidde;

- (NSInteger)indexOfItem:(id)item;
- (BOOL)firstItem:(id)item;
- (BOOL)lastItem:(id)item;

@end

@protocol SCPickerViewDelegate <NSObject>

@optional
/**
 *  选择器选择结束
 *
 *  @param item 筛选选项
 *  @param name 筛选显示名称
 */
- (void)pickerView:(SCPickerView *)pickerView didSelectRow:(NSInteger)row item:(id)item;

@end
