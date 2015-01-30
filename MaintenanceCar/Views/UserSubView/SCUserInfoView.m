//
//  SCUserInfoView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfoView.h"
#import <SCInfiniteLoopScrollView/SCInfiniteLoopScrollView.h>
#import "MicroCommon.h"
#import "SCUserInfo.h"

@implementation SCUserInfoView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self viewConfig];
}

#pragma mark - Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [_delegate shouldLogin];
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _loginButton.layer.cornerRadius = 8.0f;
}

#pragma mark - Public Methods
- (void)refresh
{
    SCUserInfo *userInfo = [SCUserInfo share];
    _loginButton.hidden  = userInfo.loginStatus;
    _userCarsView.hidden = !userInfo.loginStatus;
    
    if (!_userCarsView.hidden)
    {
        NSMutableArray *items = [@[] mutableCopy];
        for (SCUerCar *userCar in userInfo.cars)
        {
            UIView *view = [[UIView alloc] initWithFrame:_userCarsView.frame];
            view.backgroundColor = UIColorWithRGBA(arc4random()%255, arc4random()%255, arc4random()%255, 1.0f);
            [items addObject:view];
        }
        _userCarsView.subItems = items;
    }
}

@end
