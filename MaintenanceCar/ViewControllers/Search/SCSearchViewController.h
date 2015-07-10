//
//  SCSearchViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCSearchBar;
@class SCSearchHistoryView;

@interface SCSearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet         SCSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet SCSearchHistoryView *searchHistoryView;

+ (instancetype)instance;

@end
