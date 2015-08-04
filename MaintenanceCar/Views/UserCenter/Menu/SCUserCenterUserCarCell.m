//
//  SCUserCenterUserCarCell.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterUserCarCell.h"

@implementation SCUserCenterUserCarCell {
    UIColor *_selectedColor;
    UIColor *_backgroundColor;
}

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig {
    _selectedColor = [UIColor colorWithWhite:0.6f alpha:0.6f];
    _backgroundColor = self.backgroundColor;
}

- (void)viewConfig {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = _selectedColor;
}

#pragma mark - Public Methods
- (void)displayCellWithItem:(SCUserCenterMenuItem *)item selected:(BOOL)selected {
    [super displayCellWithItem:item];
    [self changeSelectedState:selected];
}

#pragma mark - Private Methods
- (void)changeSelectedState:(BOOL)selected {
    self.backgroundColor = selected ? _selectedColor : _backgroundColor;
}

@end
