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

    _normalItem.type     = SCHabitsTypeNoraml;
    _highItem.type       = SCHabitsTypeHigh;
    _oftenItem.type      = SCHabitsTypeOften;
    
    _preItem = _normalItem;
}

- (void)didSelected:(SCDriveHabitsItem *)item
{
    if (item != _preItem)
    {
        [_preItem unSelected];
        _preItem = item;
        _habitsType = item.type;
    }
}

- (void)setHabitsType:(SCHabitsType)habitsType
{
    _habitsType = habitsType;
    
    switch (habitsType)
    {
        case SCHabitsTypeHigh:
        {
            [_highItem selected];
            [self didSelected:_highItem];
        }
            break;
        case SCHabitsTypeOften:
        {
            [_oftenItem selected];
            [self didSelected:_oftenItem];
        }
            break;
            
        default:
        {
            [_normalItem selected];
            [self didSelected:_normalItem];
        }
            break;
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSaveWithHabitsType:)])
        [_delegate didSaveWithHabitsType:_habitsType];
}

@end
