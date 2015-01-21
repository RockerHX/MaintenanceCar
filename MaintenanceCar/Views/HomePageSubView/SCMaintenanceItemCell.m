//
//  SCMaintenanceItemCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceItemCell.h"
#import "MicroCommon.h"

#define LineHeight          0.5f

@implementation SCMaintenanceItemCell

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
    }
    return self;
}

#pragma mark - Private
- (void)tapGestureRecognizer
{
    self.selected = !self.selected;
    if (self.selected)
    {
        _checkBox.image = [UIImage imageNamed:@"check-box-pitch-on"];
    }
    else
    {
        _checkBox.image = [UIImage imageNamed:@"check-box-uncheck"];
    }
}

@end
