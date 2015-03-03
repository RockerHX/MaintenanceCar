//
//  SCUserViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCUserInfoView;

@interface SCUserViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCUserInfoView *userInfoView;     // 用户信息View

// [添加车辆]按钮点击事件
- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender;

@end
