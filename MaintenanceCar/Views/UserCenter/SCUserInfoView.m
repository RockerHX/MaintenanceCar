//
//  SCUserInfoView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserInfoView.h"
#import "MicroCommon.h"
#import "SCLoopScrollView.h"

@implementation SCUserInfoView

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
}

#pragma mark - Public Methods
- (void)refresh
{
    SCUserInfo *userInfo = [SCUserInfo share];
    _loginButton.hidden  = userInfo.loginStatus;
    _carInfoView.hidden  = !_loginButton.hidden;
    _userCarsView.hidden = _carInfoView.hidden;
    
    if (userInfo.loginStatus)
    {
        if (userInfo.cars.count)
        {
            if (!_userCarsView.hidden && userInfo.cars.count)
            {
                NSMutableArray *items = [@[] mutableCopy];
                for (NSInteger index = 0; index < userInfo.cars.count; index++)
                {
                    UIImageView *carView           = [[UIImageView alloc] init];
                    carView.userInteractionEnabled = YES;
                    carView.tag                    = index;
                    carView.image                  = [UIImage imageNamed:@"car"];
                    [items addObject:carView];
                }
                _userCarsView.items = items;
                
                SCUserCar *car = [userInfo.cars firstObject];
                _carNameLabel.text = [NSString stringWithFormat:@"%@%@", car.brand_name, car.model_name];
                _carDataLabel.text = [NSString stringWithFormat:@"已行驶%@公里", car.run_distance.length ? car.run_distance : @"0"];
            }
            
            __weak typeof(self)weakSelf = self;
            [_userCarsView begin:^(NSInteger index) {
                SCUserCar *car = userInfo.cars[index];
                weakSelf.carNameLabel.text = [NSString stringWithFormat:@"%@%@", car.brand_name, car.model_name];
                weakSelf.carDataLabel.text = [NSString stringWithFormat:@"已行驶%@公里", car.run_distance.length ? car.run_distance : @"0"];
            } tap:^(NSInteger index) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(shouldChangeCarData:)])
                    [weakSelf.delegate shouldChangeCarData:[SCUserInfo share].cars[index]];
            }];
        }
        else
        {
            UIImageView *carView = [[UIImageView alloc] init];
            carView.image = [UIImage imageNamed:@"car"];
            _userCarsView.items = @[carView];
            
            _carNameLabel.text = @"请在右上角添加车辆";
        }
    }
}

@end
