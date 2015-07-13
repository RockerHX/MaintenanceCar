//
//  SCLoginViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCViewControllerCategory.h"

@class SCVerificationCodeLabel;

@interface SCLoginViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;          // 手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;     // 验证码输入框
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;                   // 登录按钮
@property (weak, nonatomic) IBOutlet UIButton    *cancelButton;                  // 取消按钮

@property (weak, nonatomic) IBOutlet SCVerificationCodeLabel *verificationCodeLabel;         // 获取验证码View

// [登录]按钮触发事件
- (IBAction)loginButtonPressed;

// [取消]按钮触发事件
- (IBAction)cancelButtonPressed;

// [新浪微博]登录触发事件
- (IBAction)weiboLoginButtonPressed;

// [微信]登录触发事件
- (IBAction)weixinLoginButtonPressed;

+ (UINavigationController *)navigationInstance;
+ (instancetype)instance;

@end
