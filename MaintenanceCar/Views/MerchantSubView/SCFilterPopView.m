//
//  SCFilterPopView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterPopView.h"

#define SCFilterItemCell        @"SCFilterItemCell"

@interface SCFilterPopView ()
{
    BOOL         _canTap;
}

@end

@implementation SCFilterPopView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Private Methods
- (void)initConfig
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canTap)
        [self closePopView];
}

- (void)viewConfig
{
    _contentView.scrollsToTop      = NO;
    _contentView.tableFooterView = [[UIView alloc] init];
}

- (void)closePopView
{
    if ([_delegate respondsToSelector:@selector(shouldClosePopView)])
        [_delegate shouldClosePopView];
}

#pragma mark - Public Methods
- (void)showContentViewWithItems:(NSArray *)items
{
    _canTap = NO;
    __weak typeof(self)weakSelf = self;
    _filterItems = items;
    _contentViewHeightConstraint.constant = (items.count > 5) ? (5 * 44.0f) : (items.count * 44.0f);
    [_contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.2f animations:^{
        [weakSelf.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [weakSelf.contentView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        _canTap = YES;
    }];
}

#pragma mark - Setter And Getter Methods
- (void)setFilterItems:(NSArray *)filterItems
{
    _filterItems = filterItems;
    [_contentView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SCFilterItemCell forIndexPath:indexPath];
    cell.textLabel.text = _filterItems[indexPath.row][@"DisplayName"];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_canTap)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([_delegate respondsToSelector:@selector(didSelectedItem:)])
            [_delegate didSelectedItem:_filterItems[indexPath.row]];
    }
}

@end
