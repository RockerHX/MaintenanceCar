//
//  SCOderDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@protocol SCOderDetailViewControllerDelegate <NSObject>

@optional
- (void)shouldRefresh;

@end

@class SCOderDetail;

@interface SCOderDetailViewController : SCTableViewController
{
    BOOL          _needRefresh;
    SCOderDetail *_detail;
}

@property (nonatomic, weak)         id  <SCOderDetailViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *reserveID;
@property (nonatomic, assign)     BOOL  canPay;

@end
