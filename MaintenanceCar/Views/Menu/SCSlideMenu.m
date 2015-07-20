//
//  SCSlideMenu.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSlideMenu.h"

typedef NS_ENUM(NSUInteger, SCMenuOperateState) {
    SCMenuOperateStateWillClose,
    SCMenuOperateStateClosing,
    SCMenuOperateStateDidClose,
    SCMenuOperateStateWillOpen,
    SCMenuOperateStateOpening,
    SCMenuOperateStateDidOpen,
};

static CGFloat AnimationDuration = 0.4f;
static CGFloat AnimationDelay = 0.0f;

@implementation SCSlideMenu
{
    SCMenuOperateState _operateState;
    
    CGFloat _menuWidth;
    CGFloat _menuCloseConstant;
    CGFloat _menuOpenConstant;
}

#pragma mark - Init Methods
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initConfig];
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)initConfig
{
    _menuWidth = ([UIScreen mainScreen].bounds.size.width)/5 * 4;
    _menuCloseConstant = -_menuWidth;
    _menuOpenConstant = 0.0f;
}

- (void)viewConfig {
    _leftConstraint.constant = _menuCloseConstant;
    _widthConstraint.constant = _menuWidth;
    [self updateConstraints];
}

#pragma mark - Setter And Getter Methods
- (void)setState:(SCMenuState)state {
    _state = state;
    [self operateState:state];
}

#pragma mark - Private Methods
- (void)operateState:(SCMenuState)state {
    switch (state) {
        case SCMenuStateClose: {
            _operateState = SCMenuOperateStateWillClose;
            [self close];
            break;
        }
        case SCMenuStateOpen: {
            _operateState = SCMenuOperateStateWillOpen;
            [self open];
            break;
        }
    }
    [self setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:AnimationDuration delay:AnimationDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        _operateState = (_operateState == SCMenuOperateStateClosing) ? SCMenuOperateStateDidClose : SCMenuOperateStateDidOpen;
    }];
}

- (void)open {
    _operateState = SCMenuOperateStateOpening;
    _leftConstraint.constant = _menuOpenConstant;
}

- (void)close {
    _operateState = SCMenuOperateStateClosing;
    _leftConstraint.constant = _menuCloseConstant;
}

@end
