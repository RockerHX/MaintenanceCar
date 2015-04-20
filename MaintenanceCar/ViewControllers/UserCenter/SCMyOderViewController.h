//
//  SCMyOderViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewController.h"

@class SCNavigationTab;

@interface SCMyOderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet SCNavigationTab *navigationTab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
