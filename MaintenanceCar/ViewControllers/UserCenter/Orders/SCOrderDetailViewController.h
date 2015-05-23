//
//  SCOrderDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@protocol SCOrderDetailViewControllerDelegate <NSObject>

@optional
- (void)shouldRefresh;

@end

@class SCOrderDetail;

@interface SCOrderDetailViewController : SCTableViewController
{
    BOOL          _needRefresh;
    SCOrderDetail *_detail;
}

@property (nonatomic, weak)         id  <SCOrderDetailViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *reserveID;
@property (nonatomic, assign)     BOOL  canPay;

@end
