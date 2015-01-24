//
//  SCHomePageDetailView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageDetailView.h"
#import "MicroCommon.h"

@implementation SCHomePageDetailView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    if (IS_IPHONE_5 || IS_IPHONE_5_PRIOR)
        _carNameLabel.font = [UIFont systemFontOfSize:20.0f];
}

#pragma Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    
}

@end
