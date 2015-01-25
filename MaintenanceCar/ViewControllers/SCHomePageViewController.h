//
//  SCHomePageViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCHomePageDetailView;

@interface SCHomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCHomePageDetailView *detailView;                // 首页详情View

- (IBAction)maintenanceButtonPressed:(UIButton *)sender;
- (IBAction)repairButtonPressed:(UIButton *)sender;

@end
