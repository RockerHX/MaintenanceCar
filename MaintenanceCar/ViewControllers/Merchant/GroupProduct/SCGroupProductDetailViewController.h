//
//  SCGroupProductDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCGroupProduct;
@class SCQuotedPrice;
@class SCLoopScrollView;

@interface SCGroupProductDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCLoopScrollView *merchanImagesView;

@property (nonatomic, strong) SCGroupProduct *product;
@property (nonatomic, strong)  SCQuotedPrice *price;

@end
