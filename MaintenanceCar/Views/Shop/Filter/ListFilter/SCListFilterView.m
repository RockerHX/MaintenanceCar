//
//  SCListFilterView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListFilterView.h"
#import "SCFilterCell.h"

@implementation SCListFilterView

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig {
    _tableView.scrollsToTop = NO;
}

#pragma mark - Public Methods
- (void)setCategory:(SCFilterCategory *)category {
    _category = category;
    [_tableView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _category.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCFilterCell class]) forIndexPath:indexPath];
    [cell displayWithCategory:_category atIndex:indexPath.row];
    return cell;
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _category.selectedIndex = indexPath.row;
    SCFilterCategoryItem *item = _category.items[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedCompletedWithTitle:parameter:value:)]) {
        if (item.program) {
            [_delegate selectedCompletedWithTitle:item.filterTitle parameter:item.program value:item.value];
        } else if (_category.program) {
            [_delegate selectedCompletedWithTitle:item.filterTitle parameter:_category.program value:item.value];
        }
    }
}

@end
