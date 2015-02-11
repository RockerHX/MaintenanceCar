//
//  SCMaintenanceTypeItem.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTypeItem.h"

@implementation SCMaintenanceTypeItem

- (void)awakeFromNib
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

#pragma mark - Private
- (void)tapGestureRecognizer
{
    [self selected];
    if ([_delegate respondsToSelector:@selector(typeViewSelected:)])
        [_delegate typeViewSelected:self];
}

#pragma mark - Public Methods
- (void)selected
{
    _checkBox.image = [UIImage imageNamed:@"the-radio-pitch-on"];
    _nameLabel.textColor = [UIColor blackColor];
}

- (void)unSelected
{
    _checkBox.image = [UIImage imageNamed:@"the-radio-uncheck"];
    _nameLabel.textColor = [UIColor lightGrayColor];
}

@end
