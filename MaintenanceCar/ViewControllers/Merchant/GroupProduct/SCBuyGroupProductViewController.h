//
//  SCBuyGroupProductViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCGroupProductDetail;

@interface SCBuyGroupProductViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, strong) SCGroupProductDetail *groupProductDetail;

- (IBAction)cutButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;

- (IBAction)weiXinPayPressed:(id)sender;

@end
