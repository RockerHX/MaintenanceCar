//
//  SCOdersViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCNavigationTableViewController.h"

typedef NS_ENUM(NSInteger, SCOdersReuqest) {
    SCOdersReuqestProgress,
    SCOdersReuqestFinished
};

@class SCOder;
@class SCOderCell;

@interface SCOdersViewController : SCNavigationTableViewController <UITableViewDataSource, UITableViewDelegate>
{
    SCOder         *_oder;
    SCOderCell     *_oderCell;
    SCOdersReuqest  _odersRequest;
    
    NSInteger        _progressOffset;
    NSInteger        _finishedOffset;
    NSMutableArray  *_progressDataList;
    NSMutableArray  *_finishedDateList;
}

@property (weak, nonatomic) IBOutlet  UIView *promptView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end
