//
//  SCFilterCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterCell.h"
#import "SCFilter.h"

@implementation SCFilterCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _titleLabel.font = selected ? [UIFont boldSystemFontOfSize:20.0f] : [UIFont systemFontOfSize:17.0f];
}

- (void)displayWithItems:(NSArray *)items atIndex:(NSInteger)index
{
    SCFilterCategoryItem *item = items[index];
    _titleLabel.text = item.title;
    _bottomLine.hidden = (index == (items.count - 1));
}

@end
