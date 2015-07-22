//
//  SCMainViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCMainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

- (IBAction)showMenu;

+ (instancetype)instance;

@end
