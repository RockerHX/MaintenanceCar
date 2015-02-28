//
//  SCHomePageDetailView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCHomePageDetailView.h"
#import "MicroCommon.h"
#import "SCUserInfo.h"

@interface SCHomePageDetailView ()
{
    NSInteger         _carIndex;
    SCUserCar         *_currentCar;
}

@end

@implementation SCHomePageDetailView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    if (IS_IPHONE_5 || IS_IPHONE_5_PRIOR)
        _carNameLabel.font = [UIFont systemFontOfSize:20.0f];
    
    [self getUserCar];
    
    [_carNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
    [_carFullNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(getUserCar) name:kUserLoginSuccessNotification object:nil];
}

#pragma Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex > Zero)
    {
        _carIndex --;
        _currentCar = userInfo.cars[_carIndex];
        
        _nextButton.enabled = YES;
        if (!_carIndex)
            sender.enabled = NO;
        [self displayCarData];
    }
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    NSInteger count = userInfo.cars.count - 1;
    if (_carIndex < count)
    {
        _carIndex ++;
        _currentCar = userInfo.cars[_carIndex];
        
        _preButton.enabled = YES;
        if (_carIndex == count)
            sender.enabled = NO;
        [self displayCarData];
    }
}

#pragma mark - Private Methods
- (void)displayMaintenanceView
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
        if (userInfo.cars.count)
        {
            _preButton.hidden  = NO;
            _nextButton.hidden = _preButton.hidden;
            
            [self displayCarData];
        }
        else
            [self defaultHandelWithText:@"请添加车辆"];
    }
    else
        [self defaultHandelWithText:@"未登录"];
}

- (void)defaultHandelWithText:(NSString *)text
{
    _preButton.hidden  = YES;
    _nextButton.hidden = _preButton.hidden;
    _carNameLabel.text = text;
    _carFullNameLabel.text = @"";
}

- (void)displayCarData
{
    if (_currentCar.brand_name && _currentCar.model_name)
    {
        _carNameLabel.text     = [NSString stringWithFormat:@"%@%@", _currentCar.brand_name, _currentCar.model_name];
        _carFullNameLabel.text = _currentCar.car_full_model;
    }
    else
        [self defaultHandelWithText:@"车辆数据获取中..."];
}

- (void)tapGestureRecognizer
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (userInfo.loginStatus)
    {
        if (userInfo.cars.count)
        {
            if ([_delegate respondsToSelector:@selector(shouldChangeCarData:)])
                [_delegate shouldChangeCarData:_currentCar];
        }
        else
        {
            if ([_delegate respondsToSelector:@selector(shouldAddCar)])
                [_delegate shouldAddCar];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(shouldLogin)])
            [_delegate shouldLogin];
    }
}

#pragma mark - Public Methods
- (void)getUserCar
{
    __weak typeof(self)weakSelf = self;
    [[SCUserInfo share] userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
        if (finish)
        {
            _carIndex           = Zero;
            _nextButton.enabled = (userInfo.cars.count == 1) ? NO : YES;
            _preButton.enabled  = NO;
            _currentCar         = [userInfo.cars firstObject];
            [weakSelf displayMaintenanceView];
        }
    }];
}

- (void)refresh
{
    [self displayMaintenanceView];
}

@end
