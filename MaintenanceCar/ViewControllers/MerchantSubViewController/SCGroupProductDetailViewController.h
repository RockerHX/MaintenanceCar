//
//  SCGroupProductDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCGroupProductDetailCell;

@interface SCGroupProductDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCGroupProductDetailCell *detailCell;

@property (nonatomic, copy) NSString *productID;

@end
