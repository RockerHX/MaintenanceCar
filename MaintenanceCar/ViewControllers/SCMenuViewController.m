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
    BLOCK _block;
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

- (void)setMenuState:(SCMenuState)state completion:(void(^)(void))completion {
    _block = completion;
    _menu.state = state;
}

- (void)operateMenu {
    switch (_menu.state) {
        case SCMenuStateClose: {
            _menu.state = SCMenuStateOpen;
            break;
        }
        case SCMenuStateOpen: {
            _menu.state = SCMenuStateClose;
            break;
        }
    }
}

@end
