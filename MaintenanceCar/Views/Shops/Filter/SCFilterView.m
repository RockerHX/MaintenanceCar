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
#import "SCCarModelFilterView.h"

static CGFloat contentWidth = 140.0f;
static CGFloat contentHeight = 195.0f;
static CGFloat bottomBarHeight = 20.0f;

typedef void(^BLOCK)(NSString *param, NSString *value);

@implementation SCFilterView
{
    BLOCK _block;
    
    UIButton *_previousSelectedButton;
    UIButton *_currentSelectedButton;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _canSelected = YES;
}

- (void)viewConfig
{
    _mainFilterView.scrollsToTop = NO;
    _subFilterView.scrollsToTop = NO;
    _mainFilterView.tableFooterView = [[UIView alloc] init];
    _subFilterView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Action Methods
- (IBAction)filterButtonPressed:(UIButton *)button
{
    [_filterViewModel changeCategory:button.tag];
    _mainFilterIndex = Zero;
    [self popUp];
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
    [_carModelView hidden];
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
        }];
    }];
}

- (void)popUp
{
    [self reload];
    if (_canSelected)
    {
        _canSelected = NO;
        _heightConstraint.constant = SCREEN_HEIGHT;
        if (_filterViewModel.type == SCFilterTypeCarModel)
            _contentHeightConstraint.constant = _filterViewModel.carModelViewHeight;
        else
            _contentHeightConstraint.constant = (_filterViewModel.category.maxCount > 4) ? contentHeight : (_filterViewModel.category.maxCount*44.0f + bottomBarHeight);
        _bottomBarHeightConstraint.constant = bottomBarHeight;
        [self needsUpdateConstraints];
    }
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_popUpView layoutIfNeeded];
    } completion:^(BOOL finished) {
        _canSelected = YES;
    }];
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
        }
        else
        {
            [_carModelView hidden];
            _listFilterView.hidden = NO;
            _mainFilterViewWidthConstraint.constant = _filterViewModel.category.hasSubItems ? contentWidth : Zero;
            [_popUpView layoutIfNeeded];
            if (_filterViewModel.category.hasSubItems)
            {
                [_mainFilterView reloadData];
                [_subFilterView reloadData];
            }
            else
                [_subFilterView reloadData];
        }
    }
}

#pragma mark - Public Methods
- (void)fiflterCompleted:(void(^)(NSString *param, NSString *value))block
{
    _block = block;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_subFilterView] && _filterViewModel.category.hasSubItems)
    {
        SCFilterCategoryItem *item = _filterViewModel.category.items[_mainFilterIndex];
        return item.subItems.count;
    }
    return _filterViewModel.category.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = nil;
    if ([tableView isEqual:_subFilterView] && _filterViewModel.category.hasSubItems)
        items = ((SCFilterCategoryItem *)_filterViewModel.category.items[_mainFilterIndex]).subItems;
    else
        items = _filterViewModel.category.items;
    SCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCFilterCell" forIndexPath:indexPath];
    [cell displayWithItems:items atIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_mainFilterView])
    {
        _mainFilterIndex = indexPath.row;
        [_subFilterView reloadData];
        [_subFilterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:Zero inSection:Zero] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else if ([tableView isEqual:_subFilterView])
    {
        SCFilterCategoryItem *item = nil;
        if (_filterViewModel.category.hasSubItems)
            item = ((SCFilterCategoryItem *)_filterViewModel.category.items[_mainFilterIndex]).subItems[indexPath.row];
        else
            item = _filterViewModel.category.items[indexPath.row];
        if (_block)
        {
            if (_filterViewModel.category.program)
                _block(_filterViewModel.category.program, item.value);
            else if (item.program)
                _block(item.program, item.value);
        }
        [self packUp];
    }
}

@end
