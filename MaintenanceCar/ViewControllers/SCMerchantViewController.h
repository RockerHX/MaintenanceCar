//
//  SCMerchantViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchant;

@interface SCMerchantViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)        SCMerchant  *merchantInfo;

- (IBAction)mapItemPressed:(UIBarButtonItem *)sender;

@end
