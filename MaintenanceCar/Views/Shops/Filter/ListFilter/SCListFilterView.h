//
//  SCListFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCListFilterViewDelegate <NSObject>

@required
- (void)selectedCompletedWithTitle:(NSString *)title parameter:(NSString *)parameter value:(NSString *)value;

@end

@class SCFilterCategory;

@interface SCListFilterView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_items;
}

@property (weak, nonatomic) SCFilterCategory *category;

@property (weak, nonatomic) IBOutlet          id  <SCListFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
