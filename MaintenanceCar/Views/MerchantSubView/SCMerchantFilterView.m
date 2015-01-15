//
//  SCMerchantFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantFilterView.h"
#import "MicroCommon.h"
#import "SCFilterPopView.h"

#define MerchantFilterViewUnPopHeight   60.0f
#define MerchantFilterViewPopHeight     SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_TAB_HEIGHT

#define FilterConditionsResourceName    @"FilterConditions"
#define FilterConditionsResourceType    @"plist"

#define DistanceConditionKey            @"DistanceCondition"
#define RepariConditionKey              @"RepariCondition"
#define OtherConditionKey               @"OtherCondition"

@interface SCMerchantFilterView () <SCFilterPopViewDelegate>
{
    NSDictionary *_filterConditions;
}

@end

@implementation SCMerchantFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 加载视图之后初始化相关数据
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Action Methods
- (IBAction)distanceButtonPressed:(UIButton *)sender
{
    [self popFilterView];
    [_delegate filterButtonPressedWithType:SCFilterButtonTypeDistanceButton];
}

- (IBAction)repairTypeButtonPressed:(UIButton *)sender
{
    [self popFilterView];
    [_delegate filterButtonPressedWithType:SCFilterButtonTypeRepairTypeButton];
}

- (IBAction)otherFilterButtonPressed:(UIButton *)sender
{
    [self popFilterView];
    [_delegate filterButtonPressedWithType:SCFilterButtonTypeOtherFilterButton];
}

#pragma mark - Setter And Getter Methods

#pragma mark - Private Methods
- (void)initConfig
{
    // 设置弹出视图代理，以便回调方法触发
    _filterPopView.delegate = self;
    // 加载本地筛选条件显示数据
    _filterConditions = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FilterConditionsResourceName ofType:FilterConditionsResourceType]];
}

- (void)viewConfig
{
    // 从本地加载筛选条件数据
    @try {
        [_distanceButton setTitle:_filterConditions[DistanceConditionKey][0][DisplayNameKey] forState:UIControlStateNormal];
        [_repairTypeButton setTitle:_filterConditions[RepariConditionKey][0][DisplayNameKey] forState:UIControlStateNormal];
        [_otherFilterButton setTitle:_filterConditions[OtherConditionKey][0][DisplayNameKey] forState:UIControlStateNormal];
    }
    @catch (NSException *exception) {
        SCException(@"Read Filter Condition Error:%@", exception.reason);
    }
    @finally {
    }
}

// 弹出筛选条件View给用户展示，用户才能操作 - 带动画
- (void)popFilterView
{
    _heightConstraint.constant = MerchantFilterViewPopHeight;
    [_filterPopView showContentView];
}

// 收回筛选条件View，用户点击黑色透明部分或者选择筛选条件之后 - 带动画
- (void)closeFilterView
{
    _filterPopView.contentViewBottomConstraint.constant = MerchantFilterViewPopHeight - MerchantFilterViewUnPopHeight;
    [_filterPopView.contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_filterPopView.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            _filterPopView.alpha = DOT_COORDINATE;
        } completion:^(BOOL finished) {
            _filterPopView.contentViewBottomConstraint.constant = DOT_COORDINATE;
            _heightConstraint.constant = MerchantFilterViewUnPopHeight;
            _filterPopView.alpha = 1.0f;
        }];
    }];
}

#pragma mark - SCFilterPopViewDelegate Methods
- (void)shouldClosePopView
{
    [self closeFilterView];
}

@end
