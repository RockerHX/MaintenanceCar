//
//  SCSearchHistoryView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchHistoryView.h"
#import "SCSearchHistoryCell.h"

@interface SCSearchHistoryView () <SCSearchHistoryCellDelegate>
@end

@implementation SCSearchHistoryView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig
{
    _tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Public Methods
- (void)refresh
{
    [_tableView reloadData];
}

#pragma mark - Setter And Getter Methods
- (void)setSearchHistory:(SCSearchHistory *)searchHistory
{
    _searchHistory = searchHistory;
    [_tableView reloadData];
}

#pragma mark - Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchHistory.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCSearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SCSearchHistoryCell class]) forIndexPath:indexPath];
    [cell displayCellWithHistories:_searchHistory.history atIndex:indexPath.row];
    return cell;
}

#pragma mark -  Table View Delegaet Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSearchWithHistory:)])
        [_delegate shouldSearchWithHistory:_searchHistory.history[indexPath.row]];
}

#pragma mark - SCSearchHistoryCellDelegate Methods
- (void)shouldDeleteHistoryAtIndex:(NSInteger)index
{
    [_searchHistory deleteSearchHistoryAtIndex:index];
    [_tableView reloadData];
}

@end
