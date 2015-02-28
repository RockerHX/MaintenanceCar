//
//  SCHomePageDetailView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/24.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserCar.h"

@protocol SCHomePageDetailViewDelegate <NSObject>

@optional
- (void)shouldLogin;
- (void)shouldAddCar;
- (void)shouldChangeCarData:(SCUserCar *)userCar;

@end

@interface SCHomePageDetailView : UIView

@property (weak, nonatomic) IBOutlet  UILabel *carNameLabel;                // 车辆名称
@property (weak, nonatomic) IBOutlet  UILabel *carFullNameLabel;            // 车辆全称
@property (weak, nonatomic) IBOutlet UIButton *preButton;                   // 上一辆车按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;                  // 下一辆车按钮

@property (nonatomic, weak)                id <SCHomePageDetailViewDelegate>delegate;

- (IBAction)preCarButtonPressed:(UIButton *)sender;
- (IBAction)nextButtonPressed:(UIButton *)sender;

- (void)getUserCar;
- (void)refresh;

@end
