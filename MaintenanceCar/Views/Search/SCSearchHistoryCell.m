//
//  SCSearchHistoryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchHistoryCell.h"

@implementation SCSearchHistoryCell

#pragma mark - Action Methods
- (IBAction)deleteButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldDeleteHistoryAtIndex:)])
        [_delegate shouldDeleteHistoryAtIndex:self.tag];
}

#pragma mark - Public Methods
- (void)displayCellWithHistories:(NSArray *)histories atIndex:(NSInteger)index
{
    self.tag = index;
    _titleLabel.text = histories[index];
    
    _line.hidden = (index == (histories.count - 1));
}

@end
