//
//  SCGroupProductDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCGroupProduct;
@class SCLoopScrollView;

@interface SCGroupProductDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCLoopScrollView *merchanImagesView;

@property (nonatomic, copy) SCGroupProduct *product;

@end
