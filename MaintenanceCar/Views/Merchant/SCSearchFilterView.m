//
//  SCSearchFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchFilterView.h"
#import "AppMicroConstants.h"
#import "UIConstants.h"
#import "SCFilterPopView.h"
#import "SCAllDictionary.h"
#import "SCUserInfo.h"

#define MerchantFilterViewUnPopHeight   60.0f
#define MerchantFilterViewPopHeight     SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT

@interface SCSearchFilterView () <SCFilterPopViewDelegate>
{
    SCFilterType _filterType;
}

@end

@implementation SCSearchFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 加载视图之后初始化相关数据
    [self initConfig];
}

#pragma mark - Action Methods
- (IBAction)distanceButtonPressed:(UIButton *)sender
{
    [self popFilterViewWtihType:SCFilterTypeDistance];
}

- (IBAction)majorButtonPressed:(UIButton *)sender
{
    [[SCAllDictionary share] hanleRepairConditions:[SCUserInfo share].cars];
    [self popFilterViewWtihType:SCFilterTypeMajor];
}

- (IBAction)serviceButtonPressed:(UIButton *)sender
{
    [self popFilterViewWtihType:SCFilterTypeService];
}

#pragma mark - Setter And Getter Methods
- (void)setNoBrand:(BOOL)noBrand
{
    _noBrand = noBrand;
    if (noBrand)
    {
        _buttonWidth.constant = ZERO_POINT;
        [_majorButton setTitle:@"" forState:UIControlStateNormal];
    }
    else
        _buttonWidth.constant = (SCREEN_WIDTH - 24.0f)/3;
    [_majorButton needsUpdateConstraints];
    [_majorButton layoutIfNeeded];
}

#pragma mark - Private Methods
- (void)initConfig
{
    _filterPopView.delegate = self;     // 设置弹出视图代理，以便回调方法触发
    self.hidden = YES;
}

- (void)viewConfig
{
}

// 弹出筛选条件View给用户展示，用户才能操作 - 带动画
- (void)popFilterViewWtihType:(SCFilterType)type
{
    SCAllDictionary *allDictionary = [SCAllDictionary share];
    NSArray *filterItems = nil;
    switch (type)
    {
        case SCFilterTypeMajor:
            filterItems = allDictionary.repairConditions;
            break;
        case SCFilterTypeService:
            filterItems = allDictionary.otherConditions;
            break;
            
        default:
            filterItems = allDictionary.distanceConditions;
            break;
    }
    _filterType = type;
    _heightConstraint.constant = MerchantFilterViewPopHeight;
    [_filterPopView showContentViewWithItems:filterItems];
}

// 收回筛选条件View，用户点击黑色透明部分或者选择筛选条件之后 - 带动画
- (void)closeFilterView
{
    _filterPopView.contentViewHeightConstraint.constant = ZERO_POINT;
    [_filterPopView.contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_filterPopView.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            _filterPopView.alpha = ZERO_POINT;
        } completion:^(BOOL finished) {
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

- (void)didSelectedItem:(id)item
{
    NSString *filterName = item[DisplayNameKey];
    filterName = [item[RequestValueKey] isEqualToString:@"default"] ? [NSString stringWithFormat:@"按%@", [filterName substringToIndex:2]] : filterName;
    
    switch (_filterType)
    {
        case SCFilterTypeMajor:
            [_majorButton setTitle:filterName forState:UIControlStateNormal];
            break;
        case SCFilterTypeService:
            [_serviceButton setTitle:filterName forState:UIControlStateNormal];
            break;
            
        default:
            [_distanceButton setTitle:filterName forState:UIControlStateNormal];
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedFilterCondition:type:)])
        [_delegate didSelectedFilterCondition:item type:_filterType];
    [self closeFilterView];
}

@end
