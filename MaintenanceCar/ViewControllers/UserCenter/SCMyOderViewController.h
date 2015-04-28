//
//  SCMyOderViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCNavigationTableViewController.h"

typedef NS_ENUM(NSInteger, SCMyOderReuqest) {
    SCMyOderReuqestProgress,
    SCMyOderReuqestFinished
};

@class SCMyOder;
@class SCMyOderCell;

@interface SCMyOderViewController : SCNavigationTableViewController <UITableViewDataSource, UITableViewDelegate>
{
    SCMyOder        *_oder;
    SCMyOderCell    *_myOderCell;
    SCMyOderReuqest  _myOderRequest;
}

@end
