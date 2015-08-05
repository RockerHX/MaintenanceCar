//
//  SCUserCenterUserCarCell.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterUserCarCell.h"
#import "SCUserCenterMenuItem.h"
#import "MicroConstants.h"

@implementation SCUserCenterUserCarCell {
    SCUserCenterMenuItem *_userCarItem;
    
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
    _selectedColor = UIColorWithRGBA(51.0f, 179.0f, 246.0f, 0.9f);
    _backgroundColor = self.backgroundColor;
}

- (void)viewConfig {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = _selectedColor;
}

#pragma mark - Action
- (IBAction)editButtonPressed {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldEditUserCarData:)]) {
        [_delegate shouldEditUserCarData:_userCarItem.userCar];
    }
}

#pragma mark - Public Methods
- (void)displayCellWithItem:(SCUserCenterMenuItem *)item selected:(BOOL)selected {
    [super displayCellWithItem:item];
    
    _userCarItem = item;
    [self changeSelectedState:selected];
}

#pragma mark - Private Methods
- (void)changeSelectedState:(BOOL)selected {
    self.backgroundColor = selected ? _selectedColor : _backgroundColor;
}

@end
