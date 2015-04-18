//
//  SCMaintenanceItemCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceItemCell.h"

#define LineHeight          0.5f

@implementation SCMaintenanceItemCell

#pragma mark - Private
- (void)changCheckStatus:(BOOL)status
{
    if (status)
        _checkBox.image = [UIImage imageNamed:@"check-box-pitch-on"];
    else
        _checkBox.image = [UIImage imageNamed:@"check-box-uncheck"];
}

#pragma mark - Setter And Getter
- (void)setCheck:(BOOL)check
{
    _check        = check;
    self.selected = check;
    [self changCheckStatus:check];
}

@end
