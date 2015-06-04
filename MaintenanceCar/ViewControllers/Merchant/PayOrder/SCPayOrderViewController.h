//
//  SCPayOrderViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCOrderDetail;
@class SCGroupProduct;

@protocol SCPayOrderViewControllerDelegate <NSObject>

@optional
- (void)orderPaySucceed;

@end

@interface SCPayOrderViewController : UITableViewController

@property (nonatomic, weak)               id  <SCPayOrderViewControllerDelegate>delegate;
@property (nonatomic, strong)  SCOrderDetail *orderDetail;
@property (nonatomic, strong) SCGroupProduct *groupProduct;

+ (instancetype)instance;

@end
