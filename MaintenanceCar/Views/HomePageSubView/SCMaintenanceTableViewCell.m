//
//  SCMaintenanceTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/17.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMaintenanceTableViewCell.h"
#import "MicroCommon.h"

@implementation SCMaintenanceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.frame = CGRectZero;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10.0f;
    frame.size.width = SCREEN_WIDTH - 20.0f;
    [super setFrame:frame];
}

@end
