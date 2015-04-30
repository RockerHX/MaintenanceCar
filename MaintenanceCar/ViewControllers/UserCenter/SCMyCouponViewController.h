//
//  SCMyCouponViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/4.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@protocol SCMyCouponViewControllerDelegate <NSObject>

@optional
- (void)shouldShowOderList;

@end

@interface SCMyCouponViewController : SCTableViewController

@property (nonatomic, weak) id <SCMyCouponViewControllerDelegate>delegate;

@end
