//
//  SCServiceMerchantListViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCMerchantFilterView.h"

@interface SCServiceMerchantListViewController : UIViewController

@property (weak, nonatomic) IBOutlet SCMerchantFilterView *merchantFilterView;  // 商户列表的筛选View
@property (weak, nonatomic) IBOutlet          UITableView *tableView;           // 商户列表View

@property (nonatomic, copy)                      NSString *itemTite;
@property (nonatomic, copy)                      NSString *query;
@property (nonatomic, assign)                        BOOL isWash;

// [地图]按钮触发事件
- (IBAction)mapItemPressed:(UIBarButtonItem *)sender;

@end
