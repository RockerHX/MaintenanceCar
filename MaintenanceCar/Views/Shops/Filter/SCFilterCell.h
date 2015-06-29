//
//  SCFilterCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCFilterCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet  UIView *bottomLine;

- (void)displayWithItems:(NSArray *)items atIndex:(NSInteger)index;

@end
