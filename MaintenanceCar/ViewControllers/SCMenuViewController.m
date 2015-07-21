//
//  SCMenuViewController.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/20.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMenuViewController.h"

typedef void(^BLOCK)(void);

@implementation SCMenuViewController {
    BLOCK _closeBlock;
    BLOCK _openBlock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Touch Event
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self operateMenu];
}

#pragma mark - Public Methods
- (SCMenuState)menuState {
    return _menu.state;
}

- (void)openMenuWhenClosed:(void(^)(void))closed {
    _menu.state = SCMenuStateOpen;
    _closeBlock = closed;
}

- (void)operateMenu {
    switch (_menu.state) {
        case SCMenuStateClose: {
            _menu.state = SCMenuStateOpen;
            [UIView animateWithDuration:0.4f animations:^{
                _transparentView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
            }];
            break;
        }
        case SCMenuStateOpen: {
            _menu.state = SCMenuStateClose;
            break;
        }
    }
}

#pragma mark - Public Methods
- (void)setMenuState:(SCMenuState)state completion:(void(^)(void))completion {
    _menu.state = state;
    if (state == SCMenuStateClose) _closeBlock = completion;
    else if (state == SCMenuStateOpen) _openBlock = completion;
}

- (void)executeTransparentViewAnimationWithMenuState:(SCMenuState)state {
    [UIView animateWithDuration:0.4f animations:^{
        if (state == SCMenuStateClose) {
            _transparentView.backgroundColor = [UIColor clearColor];
        } else if (state == SCMenuStateOpen) {
            _transparentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.8f];
        }
    }];
}

#pragma mark - SCSlideMenu Delegate
- (void)menuWillClose:(SCSlideMenu *)menu {
    [self executeTransparentViewAnimationWithMenuState:SCMenuStateClose];
}
- (void)menuWillOpen:(SCSlideMenu *)menu {
    [self executeTransparentViewAnimationWithMenuState:SCMenuStateOpen];
}

- (void)menuDidClose:(SCSlideMenu *)menu {
    if (_closeBlock) _closeBlock();
}

- (void)menuDidOpen:(SCSlideMenu *)menu {
    
}

@end
