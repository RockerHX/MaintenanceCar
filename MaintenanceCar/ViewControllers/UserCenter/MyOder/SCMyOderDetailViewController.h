//
//  SCMyOderDetailViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@class SCMyOderDetail;

@interface SCMyOderDetailViewController : SCTableViewController
{
    SCMyOderDetail *_detail;
}

@property (nonatomic, strong) NSString *reserveID;

@end
