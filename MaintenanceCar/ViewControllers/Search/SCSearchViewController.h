//
//  SCSearchViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewController.h"
#import <MJRefresh/MJRefresh.h>

@class SCShopList;
@class SCFilterViewModel;
@class SCSearchBar;
@class SCSearchHistoryView;

@interface SCSearchViewController : SCViewController <UITableViewDataSource, UITableViewDelegate>
{
    SCShopList        *_shopList;
    SCFilterViewModel *_filterViewModel;
}

@property (weak, nonatomic) IBOutlet         UITableView *tableView;
@property (weak, nonatomic) IBOutlet         SCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet SCSearchHistoryView *searchHistoryView;

+ (instancetype)instance;

@end
