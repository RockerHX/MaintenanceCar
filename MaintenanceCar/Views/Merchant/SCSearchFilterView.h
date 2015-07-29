//
//  SCSearchFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

// 筛选按钮类型
typedef NS_ENUM(NSInteger, SCFilterType) {
    SCFilterTypeDistance,
    SCFilterTypeMajor,
    SCFilterTypeService
};

@protocol SCSearchFilterViewDelegate <NSObject>

@optional
// 筛选按钮被点击的时候触发此代理方法，用于弹出筛选条件
- (void)didSelectedFilterCondition:(id)item type:(SCFilterType)type;

@end

@class SCFilterPopView;

@interface SCSearchFilterView : UIView

@property (nonatomic, weak) IBOutlet                 id  <SCSearchFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet    SCFilterPopView *filterPopView;         // 筛选弹出View，展示筛选条件
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;      // 商家筛选View(SCMerchantFilterView)的高度约束条件

@property (nonatomic, weak) IBOutlet           UIButton *distanceButton;        // [距离]筛选按钮
@property (nonatomic, weak) IBOutlet           UIButton *majorButton;           // [保养类型]筛选按钮
@property (nonatomic, weak) IBOutlet           UIButton *serviceButton;         // [其他]条件筛选按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

@property (nonatomic, assign) BOOL noBrand;

// [距离]筛选按钮点击触发事件
- (IBAction)distanceButtonPressed:(UIButton *)sender;
// [保养类型]筛选按钮点击触发事件
- (IBAction)majorButtonPressed:(UIButton *)sender;
// [其他]条件筛选按钮点击触发事件
- (IBAction)serviceButtonPressed:(UIButton *)sender;

@end
