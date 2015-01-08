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

@interface SCMerchantFilterView () <SCFilterPopViewDelegate>

@end

@implementation SCMerchantFilterView

#pragma mark - Init Methods
#pragma mark -
- (void)awakeFromNib
{
    _filterPopView.delegate = self;
}

#pragma mark - Action Methods
#pragma mark -
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
#pragma mark -

#pragma mark - Private Methods
#pragma mark -
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
        _filterPopView.contentViewBottomConstraint.constant = DOT_COORDINATE;
        _heightConstraint.constant = MerchantFilterViewUnPopHeight;
    }];
}

#pragma mark - SCFilterPopViewDelegate Methods
#pragma mark -
- (void)shouldClosePopView
{
    [self closeFilterView];
}

@end
