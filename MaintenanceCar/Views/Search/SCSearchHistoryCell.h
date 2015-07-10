//
//  SCSearchHistoryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSearchHistoryCellDelegate <NSObject>

@optional
- (void)shouldDeleteHistoryAtIndex:(NSInteger)index;

@end

@interface SCSearchHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet id  <SCSearchHistoryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

- (IBAction)deleteButtonPressed;

- (void)displayCellWithHistories:(NSArray *)histories atIndex:(NSInteger)index;

@end
