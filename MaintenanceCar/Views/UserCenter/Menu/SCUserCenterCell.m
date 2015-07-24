//
//  SCUserCenterCell.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterCell.h"
#import "SCUserCenterMenuItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SCUserCenterCell

- (void)awakeFromNib {
}

#pragma mark - Public Methods
- (void)diplayCellWithItem:(SCUserCenterMenuItem *)item {
    if (item.localData) {
        [_icon setImage:[UIImage imageNamed:item.icon]];
    } else {
        [_icon sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    }
    _titleLabel.text = item.title;
}

@end
