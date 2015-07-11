//
//  SCListFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListFilterView.h"
#import "SCFilter.h"
#import "SCFilterCell.h"

@implementation SCListFilterView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig
{
    _tableView.scrollsToTop = NO;
}

#pragma mark - Public Methods
- (void)setCategory:(SCFilterCategory *)category
{
    _category = category;
    _items = category.items;
    [_tableView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCFilterCell class]) forIndexPath:indexPath];
    [cell displayWithItems:_items atIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCFilterCategoryItem *item = _items[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedCompletedWithTitle:parameter:value:)])
    {
        if (_category.program)
            [_delegate selectedCompletedWithTitle:item.title parameter:_category.program value:item.value];
        else if (item.program)
            [_delegate selectedCompletedWithTitle:item.title parameter:item.program value:item.value];
    }
}

@end
