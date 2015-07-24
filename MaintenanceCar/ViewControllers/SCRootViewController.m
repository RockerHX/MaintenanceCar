//
//  SCRootViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCMainViewController.h"
#import "UIConstants.h"

@implementation SCRootViewController

#pragma mark - Init Methods
- (void)awakeFromNib {
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    self.limitMenuViewSize = YES;
}

- (void)viewConfig {
    UINavigationController *mainNavigationController = [SCMainViewController navigationInstance];
    SCMainViewController *mainViewController = (SCMainViewController *)mainNavigationController.topViewController;
    SCUserCenterMenuViewController *menuViewController = [SCUserCenterMenuViewController instance];
    menuViewController.delegate = mainViewController;
    self.contentViewController = mainNavigationController;
    self.menuViewController = menuViewController;
    self.menuViewSize = CGSizeMake(SCREEN_WIDTH*0.75f, self.menuViewSize.height);
}

@end
