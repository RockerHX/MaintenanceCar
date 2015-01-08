//
//  SCLoginViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCVerificationCodeView;

@interface SCLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField            *phoneNumberTextField;          // 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField            *verificationCodeTextField;     // 验证码输入框
@property (weak, nonatomic) IBOutlet SCVerificationCodeView *verificationCodeView;          // 获取验证码View

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)weiboLoginButtonPressed:(UIButton *)sender;
- (IBAction)weixinLoginButtonPressed:(UIButton *)sender;

@end
