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
#pragma mark -
- (void)awakeFromNib
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView)]];
}

#pragma mark - Private Methods
#pragma mark -
- (void)closePopView
{
    [_delegate shouldClosePopView];
}

#pragma mark - Public Methods
#pragma mark -
- (void)showContentView
{
    _contentViewBottomConstraint.constant = ShowContentViewBottomConstraint;
    [_contentView needsUpdateConstraints];
    [UIView animateWithDuration:0.4f animations:^{
        [_contentView layoutIfNeeded];
    }];
}

@end
