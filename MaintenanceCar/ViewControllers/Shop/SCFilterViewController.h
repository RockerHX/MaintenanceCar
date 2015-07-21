//
//  SCFilterViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShopsViewController.h"
#import "SCFilterViewModel.h"
#import "SCFilterView.h"

@interface SCFilterViewController : SCShopsViewController

@property (weak, nonatomic) IBOutlet SCFilterView *filterView;

@property (nonatomic, strong) SCFilterViewModel *filterViewModel;

@end
