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
static CGFloat contentHeight = 200.0f;
static CGFloat bottomBarHeight = 20.0f;

typedef void(^BLOCK)(NSUInteger index);

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
    if (!_popUp)
        [self popUp];
    [self reload];
}

#pragma mark - Touch Event Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_popUp)
        [self packUp];
}

#pragma mark - Private Methods
- (void)packUp
{
    _canSelected = NO;
    _bottomBarHeightConstraint.constant = Zero;
    _contentHeightConstraint.constant = Zero;
    [self needsUpdateConstraints];
    [UIView animateWithDuration:(_filterViewModel ? 0.3f : 0.2f) delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_popUpView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            _containerView.alpha = Zero;
        } completion:^(BOOL finished) {
            _containerView.alpha = 1.0f;
            _heightConstraint.constant = _buttonHeightConstraint.constant;
            _canSelected = YES;
            _popUp = NO;
        }];
    }];
}

- (void)popUp
{
    if (_canSelected)
    {
        _canSelected = NO;
        _heightConstraint.constant = SCREEN_HEIGHT;
        _contentHeightConstraint.constant = _filterViewModel ? contentHeight : bottomBarHeight;
        _bottomBarHeightConstraint.constant = bottomBarHeight;
        [self needsUpdateConstraints];
    }
    [UIView animateWithDuration:(_filterViewModel ? 0.3f : 0.2f) delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_popUpView layoutIfNeeded];
    } completion:^(BOOL finished) {
//        [weakSelf.contentView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        _canSelected = YES;
        _popUp = YES;
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
            case SCFilterTypeModel:
            {
                _filterCategory = _filterViewModel.filter.carModelCategory;
            }
                break;
            case SCFilterTypeSort:
            {
                _filterCategory = _filterViewModel.filter.sortCategory;
            }
                break;
        }
        _contentWidthConstraint.constant = _filterCategory.hasSubItems ? contentWidth : Zero;
        if (_filterCategory.hasSubItems)
        {
            [self.mainFilterView reloadData];
            [self.subFilterView reloadData];
        }
        else
            [self.subFilterView reloadData];
    }
}

#pragma mark - Public Methods
- (void)selectedAtIndex:(void(^)(NSUInteger index))block
{
    _block = block;
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_subFilterView])
    {
        SCFilterCategoryItem *item = _filterCategory.items[_mainFilterIndex];
        return item.subItems.count;
    }
    else if ([tableView isEqual:_mainFilterView])
        return _filterCategory.items.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCategoryItem *item = nil;
    if ([tableView isEqual:_subFilterView])
        item = ((SCFilterCategoryItem *)_filterCategory.items[_mainFilterIndex]).subItems[indexPath.row];
    else if ([tableView isEqual:_mainFilterView])
        item = _filterCategory.items[indexPath.row];
    SCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCFilterCell" forIndexPath:indexPath];
    cell.titleLabel.text = item.title;
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:_mainFilterView])
        _mainFilterIndex = indexPath.row;
}

@end
