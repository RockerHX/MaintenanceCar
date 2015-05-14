//
//  SCCouponDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCGroupCoupon;
@class SCLoopScrollView;

@protocol SCCouponDetailViewControllerDelegate <NSObject>

@optional
- (void)reimburseSuccess;

@end

@interface SCCouponDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SCLoopScrollView *couponImagesView;
@property (weak, nonatomic) IBOutlet           UIView *refundView;

@property (nonatomic, weak)            id  <SCCouponDetailViewControllerDelegate>delegate;
@property (nonatomic, weak) SCGroupCoupon *coupon;

- (IBAction)refundButtonPressed:(id)sender;

@end