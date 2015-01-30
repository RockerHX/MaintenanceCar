//
//  SCUserInfoView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/30.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCUserInfoViewDelegate <NSObject>

@optional
- (void)shouldLogin;

@end

@class SCInfiniteLoopScrollView;

@interface SCUserInfoView : UIView

@property (weak, nonatomic) IBOutlet                 UIButton *loginButton;     // 登陆按钮
@property (weak, nonatomic) IBOutlet SCInfiniteLoopScrollView *userCarsView;    // 用户车辆滚动视图

@property (nonatomic, weak)                                id <SCUserInfoViewDelegate>delegate;

// [登陆]按钮点击事件
- (IBAction)loginButtonPressed:(UIButton *)sender;

- (void)refresh;

@end
