//
//  SCMaintenanceTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTableViewCell.h"
#import "UIConstants.h"

@implementation SCMaintenanceTableViewCell

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10.0f;
    frame.size.width = SCREEN_WIDTH - 20.0f;
    [super setFrame:frame];
}

@end
