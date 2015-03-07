//
//  SCGenerateGroupProductViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/7.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCGroupProductDetail;

@interface SCGenerateGroupProductViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@property (nonatomic, assign)        NSUInteger productCount;
@property (nonatomic, strong) SCGroupProductDetail *groupProductDetail;

- (IBAction)returnButtonPressed:(id)sender;

@end
