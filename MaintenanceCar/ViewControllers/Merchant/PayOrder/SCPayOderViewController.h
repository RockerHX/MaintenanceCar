//
//  SCPayOderViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCOderDetail;
@class SCGroupProduct;

@interface SCPayOderViewController : UITableViewController

@property (nonatomic, strong)   SCOderDetail *oderDetail;
@property (nonatomic, strong) SCGroupProduct *groupProduct;

+ (instancetype)instance;

@end
