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
#import "SCUerCar.h"

@interface SCHomePageDetailView ()
{
    NSInteger         _carIndex;
}

@end

@implementation SCHomePageDetailView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    if (IS_IPHONE_5 || IS_IPHONE_5_PRIOR)
        _carNameLabel.font = [UIFont systemFontOfSize:20.0f];
    
    __weak typeof(self)weakSelf = self;
    [[SCUserInfo share] userCarsReuqest:^(BOOL finish) {
        if (finish)
            [weakSelf refresh];
    }];
}

#pragma Action Methods
- (IBAction)preCarButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    if (_carIndex > Zero)
    {
        _carIndex --;
        userInfo.currentCar = userInfo.cars[_carIndex];
        
        _nextButton.enabled = YES;
        if (!_carIndex)
            sender.enabled = NO;
        [self displayMaintenanceView];
    }
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    SCUserInfo *userInfo = [SCUserInfo share];
    NSInteger count = userInfo.cars.count - 1;
    if (_carIndex < count)
    {
        _carIndex ++;
        userInfo.currentCar = userInfo.cars[_carIndex];
        
        _preButton.enabled = YES;
        if (_carIndex == count)
            sender.enabled = NO;
        [self displayMaintenanceView];
    }
}

#pragma mark - Private Methods
- (void)displayMaintenanceView
{
    SCUserInfo *userInfo   = [SCUserInfo share];
    SCUerCar *userCar      = userInfo.currentCar;
    _carNameLabel.text     = userCar.model_name ? userCar.model_name : @"元景修养";
    _carFullNameLabel.text = userCar.car_full_model ? userCar.car_full_model : @"车生活";
}

#pragma mark - Public Methods
- (void)refresh
{
    [[SCUserInfo share] refresh];
    [self displayMaintenanceView];
}

@end
