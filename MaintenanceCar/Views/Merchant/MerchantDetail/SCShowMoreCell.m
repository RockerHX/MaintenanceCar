//
//  SCShowMoreCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/15.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShowMoreCell.h"

@implementation SCShowMoreCell

#pragma mark - Setter And Getter Methods
- (void)setCount:(NSInteger)count
{
    _count = count;
    _promptLabel.text = [NSString stringWithFormat:@"评价（%@）", @(_count)];
    self.selectionStyle = count ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
}

@end
