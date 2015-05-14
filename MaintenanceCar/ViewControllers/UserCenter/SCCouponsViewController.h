//
//  SCCouponsViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@interface SCCouponsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet    UIButton *exchangeButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)ruleButtonPressed;
- (IBAction)showInvalidCoupons;

@end
