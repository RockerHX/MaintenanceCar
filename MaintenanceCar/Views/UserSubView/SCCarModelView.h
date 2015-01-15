//
//  SCCarModelView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSelectedView.h"

@class SCCarBrand;

@protocol SCCarModelViewDelegate <NSObject>

@optional
- (void)carModelViewTitleTaped;

@end

@interface SCCarModelView : SCSelectedView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView      *titleView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic, weak) id <SCCarModelViewDelegate>delegate;

- (void)showWithCarBrand:(SCCarBrand *)carBrand;
- (void)clearAllCache;
@end
