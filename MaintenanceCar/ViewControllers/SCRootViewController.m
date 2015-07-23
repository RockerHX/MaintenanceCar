//
//  SCRootViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCMainViewController.h"
#import "SCUserCenterMenuViewController.h"
#import "UIConstants.h"

@implementation SCRootViewController

#pragma mark - Init
- (void)awakeFromNib
{
    self.contentViewController = [SCMainViewController instance];
    self.menuViewController = [SCUserCenterMenuViewController instance];
    self.menuViewSize = CGSizeMake(SCREEN_WIDTH*0.75f, self.menuViewSize.height);
}

@end
