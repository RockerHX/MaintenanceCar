//
//  SCFilterCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCFilterCell.h"
#import "SCFilter.h"
#import "MicroConstants.h"

@implementation SCFilterCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    _titleLabel.font = selected ? [UIFont boldSystemFontOfSize:20.0f] : [UIFont systemFontOfSize:17.0f];
}

- (void)displayWithCategory:(SCFilterCategory *)category atIndex:(NSInteger)index {
    NSArray *items = category.items;
    SCFilterCategoryItem *item = items[index];
    _titleLabel.text = item.title;
    _bottomLine.hidden = (index == (items.count - 1));
    self.backgroundColor = (category.selectedIndex == index) ? [UIColor whiteColor] : UIColorWithRGBA(238.0f, 239.0f, 240.0f, 1.0f);
}

@end
