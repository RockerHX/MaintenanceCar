//
//  SCMaintenanceViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/26.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMileageView;
@class SCMaintenanceTypeView;

@interface SCMaintenanceViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton              *preButton;
@property (weak, nonatomic) IBOutlet UIButton              *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint    *heightConstraint;
@property (weak, nonatomic) IBOutlet UILabel               *carNameLabel;
@property (weak, nonatomic) IBOutlet UILabel               *carFullNameLabel;
@property (weak, nonatomic) IBOutlet SCMileageView         *labelView;
@property (weak, nonatomic) IBOutlet SCMaintenanceTypeView *maintenanceTypeView;

@property (weak, nonatomic) IBOutlet UILabel               *buyCarLabel;
@property (weak, nonatomic) IBOutlet UILabel               *buyCarTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel               *driveCarLabel;
@property (weak, nonatomic) IBOutlet UILabel               *driveHabitLabel;
@property (weak, nonatomic) IBOutlet UIView                *headerView;
@property (weak, nonatomic) IBOutlet UIView                *footerView;

- (IBAction)preCarButtonPressed:(UIButton *)sender;
- (IBAction)nextButtonPressed:(UIButton *)sender;

@end
