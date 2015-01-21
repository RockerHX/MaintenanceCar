//
//  SCChangeMaintenanceDataViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCChangeMaintenanceDataViewController.h"
#import "SCUserInfo.h"
#import "SCUerCar.h"

@interface SCChangeMaintenanceDataViewController ()

@end

@implementation SCChangeMaintenanceDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfig];
    [self viewConfig];
    [self viewDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)buyCarButtonPressed:(UIButton *)sender
{
}

#pragma mark - Private Methods
- (void)initConfig
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
}

- (void)viewConfig
{
    _userCarLabel.layer.borderWidth     = 1.0f;
    _userCarLabel.layer.borderColor     = [UIColor lightGrayColor].CGColor;

    _mileageTextField.layer.borderWidth = 1.0f;
    _mileageTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _buyCarDateLabel.layer.borderWidth  = 1.0f;
    _buyCarDateLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
}

- (void)viewDisplay
{
    SCUerCar *userCar = [SCUserInfo share].currentCar;
    _userCarLabel.text = userCar.model_name;
    _mileageTextField.text = userCar.run_distance;
    _buyCarDateLabel.text = [userCar.buy_car_year stringByAppendingString:userCar.buy_car_month];
}

- (void)tapGestureRecognizer
{
    [self.view endEditing:YES];
}

@end
