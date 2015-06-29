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
    _filterType = button.tag;
    _mainFilterIndex = Zero;
    [self reload];
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
    if (_canSelected)
    {
        _canSelected = NO;
        _heightConstraint.constant = SCREEN_HEIGHT;
        _contentHeightConstraint.constant = (_filterCategory.maxCount > 4) ? contentHeight : (_filterCategory.maxCount*44.0f + bottomBarHeight);
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
        switch (_filterType)
        {
            case SCFilterTypeService:
            {
                _filterCategory = _filterViewModel.filter.serviceCategory;
            }
                break;
            case SCFilterTypeRegion:
            {
                _filterCategory = _filterViewModel.filter.regionCategory;
            }
                break;
            case SCFilterTypeSort:
            {
                _filterCategory = _filterViewModel.filter.sortCategory;
            }
                break;
            case SCFilterTypeCarModel:
            {
                _filterCategory = _filterViewModel.filter.carModelCategory;
            }
                break;
        }
        _mainFilterViewWidthConstraint.constant = _filterCategory.hasSubItems ? contentWidth : Zero;
        [_popUpView layoutIfNeeded];
        if (_filterCategory.hasSubItems)
        {
            [_mainFilterView reloadData];
            [_subFilterView reloadData];
        }
        else
            [_subFilterView reloadData];
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
    if ([tableView isEqual:_subFilterView] && _filterCategory.hasSubItems)
    {
        SCFilterCategoryItem *item = _filterCategory.items[_mainFilterIndex];
        return item.subItems.count;
    }
    return _filterCategory.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = nil;
    if ([tableView isEqual:_subFilterView] && _filterCategory.hasSubItems)
        items = ((SCFilterCategoryItem *)_filterCategory.items[_mainFilterIndex]).subItems;
    else
        items = _filterCategory.items;
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
        if (_filterCategory.hasSubItems)
            item = ((SCFilterCategoryItem *)_filterCategory.items[_mainFilterIndex]).subItems[indexPath.row];
        else
            item = _filterCategory.items[indexPath.row];
        if (_block)
        {
            if (_filterCategory.program)
                _block(_filterCategory.program, item.value);
            else if (item.program)
                _block(item.program, item.value);
        }
        [self packUp];
    }
}

@end
