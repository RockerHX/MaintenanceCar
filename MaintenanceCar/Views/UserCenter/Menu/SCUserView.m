//
//  SCUserView.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserView.h"

@implementation SCUserView

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig {
    _header.layer.cornerRadius = _header.frame.size.width/2;
}

@end
