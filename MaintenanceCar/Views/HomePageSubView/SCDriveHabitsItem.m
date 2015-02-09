//
//  SCDriveHabitsItem.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDriveHabitsItem.h"

@implementation SCDriveHabitsItem

- (void)awakeFromNib
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

#pragma mark - Private Methods
- (void)tapGestureRecognizer
{
    [self selected];
    
    if ([_delegate respondsToSelector:@selector(didSelected:)])
        [_delegate didSelected:self];
}

- (void)selected
{
    _checkBox.image = [UIImage imageNamed:@"CheckButton"];
}

- (void)unSelected
{
    _checkBox.image = [UIImage imageNamed:@"UnCheckButton"];
}

@end
