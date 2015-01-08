//
//  SCMerchantViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchant;
@class SCMerchantFilterView;

@interface SCMerchantViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCMerchantFilterView *merchantFilterView;
@property (weak, nonatomic) IBOutlet UITableView          *tableView;

- (IBAction)mapItemPressed:(UIBarButtonItem *)sender;

@end
