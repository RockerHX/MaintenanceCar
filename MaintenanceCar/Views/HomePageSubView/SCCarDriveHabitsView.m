//
//  SCCarDriveHabitsView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCarDriveHabitsView.h"
#import "SCDriveHabitsItem.h"

@interface SCCarDriveHabitsView () <SCDriveHabitsItemDelegate>
{
    SCDriveHabitsItem *_preItem;
}

@end

@implementation SCCarDriveHabitsView

- (void)awakeFromNib
{
    _normalItem.delegate = self;
    _highItem.delegate   = self;
    _oftenItem.delegate  = self;
    
    _preItem = _normalItem;
}

- (void)didSelected:(SCDriveHabitsItem *)item
{
    if (item != _preItem)
    {
        [_preItem unSelected];
        _preItem = item;
    }
}

@end
