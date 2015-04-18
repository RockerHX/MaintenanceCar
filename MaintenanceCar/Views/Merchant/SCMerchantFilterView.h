//
//  SCMerchantFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

// 筛选按钮类型
typedef NS_ENUM(NSInteger, SCFilterType) {
    SCFilterTypeDistance,
    SCFilterTypeRepair,
    SCFilterTypeOther
};

@protocol SCMerchantFilterViewDelegate <NSObject>

@optional
// 筛选按钮被点击的时候触发此代理方法，用于弹出筛选条件
- (void)didSelectedFilterCondition:(id)item type:(SCFilterType)type;

@end

@class SCFilterPopView;

@interface SCMerchantFilterView : UIView

@property (nonatomic, weak)                          id <SCMerchantFilterViewDelegate>delegate;
@property (nonatomic, assign)                      BOOL noBrand;


@property (weak, nonatomic) IBOutlet    SCFilterPopView *filterPopView;         // 筛选弹出View，展示筛选条件
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;      // 商家筛选View(SCMerchantFilterView)的高度约束条件

@property (nonatomic, weak) IBOutlet           UIButton *distanceButton;        // [距离]筛选按钮
@property (nonatomic, weak) IBOutlet           UIButton *repairTypeButton;      // [保养类型]筛选按钮
@property (nonatomic, weak) IBOutlet           UIButton *otherFilterButton;     // [其他]条件筛选按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

// [距离]筛选按钮点击触发事件
- (IBAction)distanceButtonPressed:(UIButton *)sender;
// [保养类型]筛选按钮点击触发事件
- (IBAction)repairTypeButtonPressed:(UIButton *)sender;
// [其他]条件筛选按钮点击触发事件
- (IBAction)otherFilterButtonPressed:(UIButton *)sender;

@end
