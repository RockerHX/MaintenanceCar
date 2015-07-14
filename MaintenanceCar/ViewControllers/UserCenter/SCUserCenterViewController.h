//
//  SCUserCenterViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/19.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCUserInfoView;

@interface SCUserCenterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCUserInfoView *userInfoView;     // 用户信息View

// [添加车辆]按钮点击事件
- (IBAction)addCarItemPressed:(UIBarButtonItem *)sender;

+ (instancetype)instance;
+ (NSString *)navgationRestorationIdentifier;

@end