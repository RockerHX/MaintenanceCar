//
//  SCCouponDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"

@class SCCoupon;

@protocol SCCouponDetailViewControllerDelegate <NSObject>

@optional
- (void)reimburseSuccess;

@end

@interface SCCouponDetailViewController : UITableViewController

@property (nonatomic, weak)       id <SCCouponDetailViewControllerDelegate>delegate;
@property (nonatomic, weak) SCCoupon *coupon;

- (IBAction)reimburseButtonPressed:(id)sender;

@end
