//
//  SCUserInfoView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUserInfo.h"

@protocol SCUserInfoViewDelegate <NSObject>

@optional
- (void)shouldLogin;
- (void)shouldChangeCarData:(SCUserCar *)userCar;

@end

@class SCInfiniteLoopScrollView;

@interface SCUserInfoView : UIView

@property (weak, nonatomic) IBOutlet                 UIButton *loginButton;     // 登录按钮
@property (weak, nonatomic) IBOutlet                   UIView *carInfoView;     // 用户车辆信息View
@property (weak, nonatomic) IBOutlet                  UILabel *carNameLabel;    // 用户车辆名称栏
@property (weak, nonatomic) IBOutlet                  UILabel *carDataLabel;    // 用户车辆数据栏
@property (weak, nonatomic) IBOutlet SCInfiniteLoopScrollView *userCarsView;    // 用户车辆滚动View

@property (nonatomic, weak)                                id <SCUserInfoViewDelegate>delegate;

// [登录]按钮点击事件
- (IBAction)loginButtonPressed:(UIButton *)sender;

- (void)refresh;

@end
