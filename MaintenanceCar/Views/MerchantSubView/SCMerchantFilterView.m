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
#import "SCAllDictionary.h"

#define MerchantFilterViewUnPopHeight   60.0f
#define MerchantFilterViewPopHeight     SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT

#define FilterConditionsResourceName    @"FilterConditions"
#define FilterConditionsResourceType    @"plist"

#define DistanceConditionKey            @"DistanceCondition"
#define RepairConditionKey              @"RepairCondition"
#define OtherConditionKey               @"OtherCondition"

@interface SCMerchantFilterView () <SCFilterPopViewDelegate>
{
    SCFilterType _filterType;
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
    [self popFilterViewWtihType:SCFilterTypeDistance];
}

- (IBAction)repairTypeButtonPressed:(UIButton *)sender
{
    [self popFilterViewWtihType:SCFilterTypeRepair];
}

- (IBAction)otherFilterButtonPressed:(UIButton *)sender
{
    [self popFilterViewWtihType:SCFilterTypeOther];
}

#pragma mark - Setter And Getter Methods

#pragma mark - Private Methods
- (void)initConfig
{
    _filterPopView.delegate = self;     // 设置弹出视图代理，以便回调方法触发
    // 加载本地筛选条件显示数据
    NSDictionary *localData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:FilterConditionsResourceName ofType:FilterConditionsResourceType]];
    
    NSMutableDictionary *filterConditions = [localData mutableCopy];
    NSMutableArray *repairConditions = [NSMutableArray arrayWithArray:localData[RepairConditionKey]];
    NSMutableArray *otherConditions = [NSMutableArray arrayWithArray:localData[OtherConditionKey]];
    
    [filterConditions setObject:repairConditions forKey:RepairConditionKey];
    [filterConditions setObject:otherConditions forKey:OtherConditionKey];
    _filterConditions = filterConditions;
}

- (void)viewConfig
{
    [_distanceButton setTitle:@"按距离" forState:UIControlStateNormal];
    [_repairTypeButton setTitle:@"按品牌" forState:UIControlStateNormal];
    [_otherFilterButton setTitle:@"按业务" forState:UIControlStateNormal];
}

// 弹出筛选条件View给用户展示，用户才能操作 - 带动画
- (void)popFilterViewWtihType:(SCFilterType)type
{
    NSArray *filterItems = nil;
    switch (type)
    {
        case SCFilterTypeRepair:
            filterItems = _filterConditions[RepairConditionKey];
            break;
        case SCFilterTypeOther:
            filterItems = _filterConditions[OtherConditionKey];
            break;
            
        default:
            filterItems = _filterConditions[DistanceConditionKey];
            break;
    }
    _filterType = type;
    _heightConstraint.constant = MerchantFilterViewPopHeight;
    [_filterPopView showContentViewWithItems:filterItems];
}

// 收回筛选条件View，用户点击黑色透明部分或者选择筛选条件之后 - 带动画
- (void)closeFilterView
{
    _filterPopView.contentViewHeightConstraint.constant = DOT_COORDINATE;
    [_filterPopView.contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.3f animations:^{
        [_filterPopView.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            _filterPopView.alpha = DOT_COORDINATE;
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
    NSString *filterName      = item[DisplayNameKey];
    NSString *filterCondition = item[RequestValueKey];
    switch (_filterType)
    {
        case SCFilterTypeRepair:
            [_repairTypeButton setTitle:filterName forState:UIControlStateNormal];
            break;
        case SCFilterTypeOther:
            [_otherFilterButton setTitle:filterName forState:UIControlStateNormal];
            break;
            
        default:
            [_distanceButton setTitle:filterName forState:UIControlStateNormal];
            break;
    }
    [_delegate didSelectedFilterCondition:filterCondition type:_filterType];
    [self closeFilterView];
}

@end
