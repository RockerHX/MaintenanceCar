//
//  SCGroupTicketsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCListViewController.h"

@protocol SCGroupTicketsViewControllerDelegate <NSObject>

@optional
- (void)shouldShowMenu;

@end

@interface SCGroupTicketsViewController : SCListViewController

@property (nonatomic, weak) id  <SCGroupTicketsViewControllerDelegate>delegate;

- (IBAction)menuButtonPressed;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
