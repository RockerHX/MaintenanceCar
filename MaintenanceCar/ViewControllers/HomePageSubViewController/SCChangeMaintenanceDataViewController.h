//
//  SCChangeMaintenanceDataViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCar;

@interface SCChangeMaintenanceDataViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel     *userCarLabel;
@property (weak, nonatomic) IBOutlet UITextField *mileageTextField;
@property (weak, nonatomic) IBOutlet UILabel     *buyCarDateLabel;

- (IBAction)buyCarButtonPressed:(UIButton *)sender;

@end
