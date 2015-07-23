//
//  SCUserCenterMenuViewController.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCUserView;
@interface SCUserCenterMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet         SCUserView *userView;
@property (weak, nonatomic) IBOutlet        UITableView *userCarView;
@property (weak, nonatomic) IBOutlet        UITableView *userCenterView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userCarHeightConstraint;

+ (instancetype)instance;

@end
