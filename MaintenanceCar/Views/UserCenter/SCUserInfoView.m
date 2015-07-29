//
//  SCUserInfoView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfoView.h"
#import <SCLoopScrollView/SCLoopScrollView.h>

@implementation SCUserInfoView
{
    SCUserCar *_currentCar;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self viewConfig];
}

#pragma mark - Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldLogin)])
        [_delegate shouldLogin];
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _loginButton.layer.cornerRadius = 8.0f;
    
    [_carInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeCarData)]];
}

- (void)displayLabelWithCar:(SCUserCar *)car
{
    _currentCar = car;
    _carNameLabel.text = [NSString stringWithFormat:@"%@%@", _currentCar.brand_name, _currentCar.model_name];
    _carDataLabel.text = [NSString stringWithFormat:@"已行驶%@公里", _currentCar.run_distance.length ? _currentCar.run_distance : @"0"];
}

- (void)changeCarData
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldChangeCarData:)] && [SCUserInfo share].cars.count)
        [_delegate shouldChangeCarData:_currentCar];
}

#pragma mark - Public Methods
- (void)refresh
{
    SCUserInfo *userInfo = [SCUserInfo share];
    _loginButton.hidden  = userInfo.loginState;
    _carInfoView.hidden  = !_loginButton.hidden;
    _userCarsView.hidden = _carInfoView.hidden;
    
    if (userInfo.loginState)
    {
        if (!userInfo.cars.count)
        {
            _userCarsView.defaultImage = [UIImage imageNamed:@"UserCarBG"];
            _carNameLabel.text = @"请在右上角添加车辆";
            _carDataLabel.text = @"";
            [_userCarsView show:nil finished:nil];
        }
        
        __weak typeof(self)weakSelf = self;
        [userInfo userCarsReuqest:^(SCUserInfo *userInfo, BOOL finish) {
            if (!_userCarsView.hidden && userInfo.cars.count)
            {
                NSMutableArray *images = @[].mutableCopy;
                for (NSInteger index = 0; index < userInfo.cars.count; index++)
                    [images addObject:[UIImage imageNamed:@"UserCarBG"]];
                _userCarsView.images = images;
                [self displayLabelWithCar:[userInfo.cars firstObject]];
            }
            
            [_userCarsView show:^(NSInteger index) {
                if (userInfo.cars.count)
                {
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shouldChangeCarData:)])
                        [weakSelf.delegate shouldChangeCarData:userInfo.cars[index]];
                }
            } finished:^(NSInteger index) {
                [weakSelf displayLabelWithCar:userInfo.cars[index]];
            }];
        }];
    }
}

@end
