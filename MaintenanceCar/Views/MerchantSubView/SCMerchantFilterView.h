//
//  SCMerchantFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCFilterButtonType) {
    SCFilterButtonTypeDefault           = 1000,
    SCFilterButtonTypeDistanceButton    = SCFilterButtonTypeDefault,
    SCFilterButtonTypeRepairTypeButton  = 1001,
    SCFilterButtonTypeOtherFilterButton = 1002
};

@protocol SCMerchantFilterViewDelegate <NSObject>

@optional
// 筛选按钮被点击的时候触发此代理方法，用于弹出筛选条件
- (void)filterButtonPressedWithType:(SCFilterButtonType)type;

@end

@class SCFilterPopView;

@interface SCMerchantFilterView : UIView

@property (nonatomic, weak)                          id <SCMerchantFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet    SCFilterPopView *filterPopView;         // 筛选弹出View，展示筛选条件
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;      // 商户筛选View(SCMerchantFilterView)的高度约束条件

- (IBAction)distanceButtonPressed:(UIButton *)sender;
- (IBAction)repairTypeButtonPressed:(UIButton *)sender;
- (IBAction)otherFilterButtonPressed:(UIButton *)sender;

@end
