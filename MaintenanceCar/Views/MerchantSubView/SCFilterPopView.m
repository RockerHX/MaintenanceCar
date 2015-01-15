//
//  SCFilterPopView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterPopView.h"

#define ShowContentViewBottomConstraint        100.0f

@implementation SCFilterPopView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 添加单击手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)]];
}

#pragma mark - Private Methods
- (void)closePopView
{
    [_delegate shouldClosePopView];
}

#pragma mark - Public Methods
- (void)showContentView
{
    _contentViewBottomConstraint.constant = ShowContentViewBottomConstraint;
    [_contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.4f animations:^{
        [_contentView layoutIfNeeded];
    }];
}

@end
