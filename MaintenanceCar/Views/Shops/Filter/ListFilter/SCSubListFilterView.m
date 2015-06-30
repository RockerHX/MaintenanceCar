//
//  SCSubListFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSubListFilterView.h"
#import "SCFilter.h"
#import "SCFilterCell.h"

@implementation SCSubListFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig
{
    _mainFilterView.scrollsToTop = NO;
    _subFilterView.scrollsToTop = NO;
    _mainFilterView.tableFooterView = [[UIView alloc] init];
    _subFilterView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Setter And Getter Methods
- (void)setCategory:(SCFilterCategory *)category
{
    _category = category;
    _mainItems = category.items;
    _subItems = ((SCFilterCategoryItem *)[category.items firstObject]).subItems;
    [_mainFilterView reloadData];
    [_subFilterView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_mainFilterView])
        return _mainItems.count;
    else if ([tableView isEqual:_subFilterView])
        return _subItems.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = nil;
    if ([tableView isEqual:_mainFilterView])
        items = _mainItems;
    else if ([tableView isEqual:_subFilterView])
        items = _subItems;
    SCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCFilterCell class]) forIndexPath:indexPath];
    [cell displayWithItems:items atIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_mainFilterView])
    {
        _mainFilterIndex = indexPath.row;
        _subItems = ((SCFilterCategoryItem *)_category.items[_mainFilterIndex]).subItems;
        if (_subItems.count)
        {
            [_subFilterView reloadData];
            [_subFilterView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            if (_category.program)
                [_delegate selectedCompletedWithParameter:_category.program value:_category.value];
        }
    }
    else if ([tableView isEqual:_subFilterView])
    {
        SCFilterCategoryItem *item = _subItems[indexPath.row];
        if (_delegate && [_delegate respondsToSelector:@selector(selectedCompletedWithParameter:value:)])
        {
            if (_category.program)
                [_delegate selectedCompletedWithParameter:_category.program value:item.value];
            else if (item.program)
                [_delegate selectedCompletedWithParameter:item.program value:item.value];
        }
    }
}

@end
