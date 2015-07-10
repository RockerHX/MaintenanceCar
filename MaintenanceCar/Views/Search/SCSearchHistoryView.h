//
//  SCSearchHistoryView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSearchHistory.h"

@protocol SCSearchHistoryViewDelegate <NSObject>

@optional
- (void)shouldSearchWithHistory:(NSString *)history;

@end

@class SCSearchHistory;

@interface SCSearchHistoryView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic)  SCSearchHistory *searchHistory;

@property (weak, nonatomic) IBOutlet          id  <SCSearchHistoryViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)refresh;

@end
