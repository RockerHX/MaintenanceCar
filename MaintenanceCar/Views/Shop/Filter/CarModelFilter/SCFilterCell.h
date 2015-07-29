//
//  SCFilterCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCFilter.h"

@interface SCFilterCell : UITableViewCell

@property (weak, nonatomic) IBOutlet            UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet             UIView *bottomLine;

- (void)displayWithCategory:(SCFilterCategory *)category atIndex:(NSInteger)index;

@end
