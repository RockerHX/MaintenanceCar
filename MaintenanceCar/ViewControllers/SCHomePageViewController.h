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
@property (weak, nonatomic) IBOutlet UIButton             *specialButton;             // 首页第四个按钮
@property (weak, nonatomic) IBOutlet UILabel              *specialLabel;              // 首页第四个文字栏

- (IBAction)maintenanceButtonPressed:(UIButton *)sender;
- (IBAction)SpecialButtonPressed:(UIButton *)sender;

@end
