//
//  SCMyOderDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@protocol SCMyOderDetailViewControllerDelegate <NSObject>

@optional
- (void)shouldRefresh;

@end

@class SCMyOderDetail;

@interface SCMyOderDetailViewController : SCTableViewController
{
    BOOL            _needRefresh;
    SCMyOderDetail *_detail;
}

@property (nonatomic, weak)         id  <SCMyOderDetailViewControllerDelegate>delegate;
@property (nonatomic, strong) NSString *reserveID;

@end
