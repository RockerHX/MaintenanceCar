//
//  SCRootViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCHomePageViewController.h"

@implementation SCRootViewController

#pragma mark - Init
- (void)awakeFromNib
{
    self.contentViewController = [SCHomePageViewController instance];
//    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuController"];
}

@end
