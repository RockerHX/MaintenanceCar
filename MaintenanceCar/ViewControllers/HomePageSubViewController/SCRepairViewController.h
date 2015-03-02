//
//  SCRepairViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCMerchant;
@class SCMerchantFilterView;

@interface SCRepairViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCMerchantFilterView *merchantFilterView;  // 商家列表的筛选View
@property (weak, nonatomic) IBOutlet UITableView          *tableView;           // 商家列表View

@end
