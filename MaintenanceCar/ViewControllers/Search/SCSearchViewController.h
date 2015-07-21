//
//  SCSearchViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopsViewController.h"

@class SCSearchBar;
@class SCSearchHistoryView;

@interface SCSearchViewController : SCShopsViewController

@property (weak, nonatomic) IBOutlet         SCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet              UIView *searchSubView;
@property (weak, nonatomic) IBOutlet SCSearchHistoryView *searchHistoryView;

+ (UINavigationController *)navigationInstance;

@end
