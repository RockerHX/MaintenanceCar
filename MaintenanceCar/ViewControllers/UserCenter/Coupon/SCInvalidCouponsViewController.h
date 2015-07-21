//
//  SCInvalidCouponsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCInvalidCouponsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)ruleButtonPressed;

+ (instancetype)instance;

@end
