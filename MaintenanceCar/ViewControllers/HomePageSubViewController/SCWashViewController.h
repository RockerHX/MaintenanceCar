//
//  SCWashViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantViewController.h"

@class SCMerchant;
@class SCMerchantFilterView;

@interface SCWashViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCMerchantFilterView *merchantFilterView;  // 商户列表的筛选View
@property (weak, nonatomic) IBOutlet UITableView          *tableView;           // 商户列表View

@end
