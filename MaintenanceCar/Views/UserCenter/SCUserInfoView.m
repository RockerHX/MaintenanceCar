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

@implementation SCUserInfoView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self viewConfig];
}

#pragma mark - Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(shouldLogin)])
        [_delegate shouldLogin];
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _loginButton.layer.cornerRadius = 8.0f;
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(shouldChangeCarData:)])
        [_delegate shouldChangeCarData:[SCUserInfo share].cars[tap.view.tag]];
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
                    [carView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)]];
                    [items addObject:carView];
                }
                _userCarsView.subItems = items;
                
                SCUserCar *car = [userInfo.cars firstObject];
                _carNameLabel.text = [NSString stringWithFormat:@"%@%@", car.brand_name, car.model_name];
                _carDataLabel.text = [NSString stringWithFormat:@"已行驶%@公里", car.run_distance.length ? car.run_distance : @"0"];
            }
            
            __weak typeof(self)weakSelf = self;
            [_userCarsView startAnimation:^(NSInteger index, BOOL animated) {
                SCUserCar *car = userInfo.cars[index];
                weakSelf.carNameLabel.text = [NSString stringWithFormat:@"%@%@", car.brand_name, car.model_name];
                weakSelf.carDataLabel.text = [NSString stringWithFormat:@"已行驶%@公里", car.run_distance.length ? car.run_distance : @"0"];
            }];
        }
        else
        {
            UIImageView *carView = [[UIImageView alloc] init];
            carView.image = [UIImage imageNamed:@"car"];
            _userCarsView.subItems = @[carView];
            
            _carNameLabel.text = @"请在右上角添加车辆";
        }
    }
}

@end
