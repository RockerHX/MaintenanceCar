//
//  SCFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterView.h"
#import "MicroConstants.h"
#import "SCFilterViewModel.h"
#import "SCFilterCell.h"
#import "SCListFilterView.h"
#import "SCSubListFilterView.h"
#import "SCCarModelFilterView.h"

typedef void(^BLOCK)(NSString *param, NSString *value);

@interface SCFilterView () <SCListFilterViewDelegate, SCSubListFilterViewDelegate, SCCarModelFilterViewDelegate>
{
    BLOCK _block;
    BOOL  _canSelected;
    
    UIButton *_selectedButton;
}

@end

@implementation SCFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _canSelected = YES;
}

#pragma mark - Action Methods
- (IBAction)filterButtonPressed:(UIButton *)button
{
    if (!((_state == SCFilterViewStateOpen) && (_selectedButton.tag == button.tag)))
    {
        _selectedButton = button;
        [_filterViewModel changeCategory:button.tag];
        [self popUp];
        [self reload];
    }
    else
        [self packUp];
}

#pragma mark - Setter And Getter Methods
- (void)setState:(SCFilterViewState)state
{
    _state = state;
    switch (state)
    {
        case SCFilterViewStateOpen:
            [self popUp];
            break;
        case SCFilterViewStateClose:
            [self packUp];
            break;
    }
}

#pragma mark - Touch Event Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self packUp];
}

#pragma mark - Private Methods
- (void)packUp
{
    _canSelected = NO;
    _bottomBarHeightConstraint.constant = Zero;
    _contentHeightConstraint.constant = Zero;
    [self needsUpdateConstraints];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_popUpView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            _containerView.alpha = Zero;
        } completion:^(BOOL finished) {
            _containerView.alpha = 1.0f;
            _heightConstraint.constant = _buttonHeightConstraint.constant;
            _canSelected = YES;
            _state = SCFilterViewStateClose;
        }];
    }];
}

- (void)popUp
{
    if (_canSelected)
    {
        _canSelected = NO;
        _heightConstraint.constant = SCREEN_HEIGHT;
        _contentHeightConstraint.constant = _filterViewModel.contentHeight;
        _bottomBarHeightConstraint.constant = bottomBarHeight;
        [self needsUpdateConstraints];
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_popUpView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _canSelected = YES;
            _state = SCFilterViewStateOpen;
        }];
    }
}

- (void)reload
{
    if (_filterViewModel)
    {
        if ([_filterViewModel.category isKindOfClass:[SCCarModelFilterCategory class]])
        {
            _carModelView.category = _filterViewModel.filter.carModelCategory;
            [_carModelView show];
            _listFilterView.hidden = YES;
            _subListFilterView.hidden = YES;
        }
        else
        {
            SCFilterCategory *category = _filterViewModel.category;
            BOOL haveSubItems = category.haveSubItems;
            
            [_carModelView hidden];
            _listFilterView.hidden = haveSubItems;
            _subListFilterView.hidden = !haveSubItems;
            
            if (haveSubItems)
                _subListFilterView.category = category;
            else
                _listFilterView.category = category;
        }
    }
}

#pragma mark - Public Methods
- (void)filterCompleted:(void(^)(NSString *param, NSString *value))block
{
    _block = block;
}

#pragma mark - SCCarModelFilterViewDelegate Methods
- (void)selectedCompletedWithTitle:(NSString *)title parameter:(NSString *)parameter value:(NSString *)value
{
    if (_block)
    {
        [_selectedButton setTitle:title forState:UIControlStateNormal];
        _block(parameter, value);
    }
    [self packUp];
}

@end
