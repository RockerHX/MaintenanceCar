//
//  SCSubListFilterView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSubListFilterViewDelegate <NSObject>

@required
- (void)selectedCompletedWithTitle:(NSString *)title parameter:(NSString *)parameter value:(NSString *)value;

@end

@class SCFilterCategory;

@interface SCSubListFilterView : UIView <UITableViewDataSource, UITableViewDelegate> {
    NSInteger _mainFilterIndex;
    
    NSArray  *_mainItems;
    NSArray  *_subItems;
}

@property (weak, nonatomic) SCFilterCategory *category;

@property (weak, nonatomic) IBOutlet          id  <SCSubListFilterViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *mainFilterView;
@property (weak, nonatomic) IBOutlet UITableView *subFilterView;

@end
