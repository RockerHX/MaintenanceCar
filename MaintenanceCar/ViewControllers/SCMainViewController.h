//
//  SCMainViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"
#import "SCUserCenterMenuViewController.h"

@interface SCMainViewController : UIViewController <SCUserCenterMenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)showMenu;

+ (instancetype)instance;
+ (UINavigationController *)navigationInstance;

@end
