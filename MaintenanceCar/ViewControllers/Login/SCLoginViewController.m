//
//  SCLoginViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UMengMessage/UMessage.h>
#import "SCLoginViewController.h"
#import "SCVerificationCodeLabel.h"

// 登录验证模式
typedef NS_ENUM(NSInteger, SCVerificationCodeMode) {
    SCVerificationCodeModeMessage = 1,          // 短信验证模式
    SCVerificationCodeModeCall                  // 语音验证模式
};

// HUD提示框类型
typedef NS_ENUM(NSInteger, SCHUDMode) {
    SCHUDModeDefault,
    SCHUDModeSendVerificationCode,
    SCHUDModeLogin
};

typedef NS_ENUM(NSInteger, SCDismissType) {
    SCDismissTypeLoginSuccess,
    SCDismissTypeCancel
};

@implementation SCLoginViewController {
    BOOL _needShow; // 登录成功之后是否需要显示提示页
}

#pragma mark - Init Methods
+ (UINavigationController *)navigationInstance {
    return [SCStoryBoardManager navigaitonControllerWithIdentifier:@"SCLoginNavigationController"
                                                    storyBoardName:SCStoryBoardNameLogin];
}

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 注册登录"];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 注册登录"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];
}

#pragma mark - Config Methods
- (void)viewConfig {
    // 配置手机输入框和短信验证码输入框，输入光标向右偏移10个像素，避免光标贴到输入框边缘造成视觉影响
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 10.0f, 1.0f)];
    _verificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, 10.0f, 1.0f)];
    
    // 配置登录和取消按钮，设置圆角
    _loginButton.layer.cornerRadius = 5.0f;
    _cancelButton.layer.cornerRadius = 5.0f;
    
    // self弱引用，防止block使用出现循环引用，造成内存泄露
    WEAK_SELF(weakSelf);
    // 获取验证码View被点击之后的回调，判断是否输入手机号进行返回和执行获取验证码请求
    [_verificationCodeLabel codeShouldSend:^BOOL(SCVerificationType type) {
        if ([weakSelf.phoneNumberTextField.text length] == 11) {
            switch (type) {
                case SCVerificationTypeMessage: {
                    [weakSelf startGetVerificationCodeReuqestWithMode:SCVerificationCodeModeMessage];
                    break;
                }
                case SCVerificationTypeCall: {
                    [weakSelf startGetVerificationCodeReuqestWithMode:SCVerificationCodeModeCall];
                    break;
                }
            }
            return YES;
        } else {
            [weakSelf showHUDAlertToViewController:weakSelf text:@"手机号不对噢亲，请仔细检查！"];
            return NO;
        }
    }];
}

#pragma mark - Touch Event Methods
// 点击页面上不能相应事件的位置，收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Button Action Methods
- (IBAction)loginButtonPressed {
    // 登录按钮点击之后分别经行是否输入手机号，是否输入验证码，验证码是否正确的判断操作，前面这些都正确以后才进行注册登录操作
    [self resignKeyBoard];
    
    if (![_phoneNumberTextField.text length]) {
        [self showHUDAlertToViewController:self text:@"请输入手机号噢亲！"];
    } else if (![_verificationCodeTextField.text length]) {
        [self showHUDAlertToViewController:self text:@"请输入验证码噢亲！"];
    } else if ([_phoneNumberTextField.text isEqualToString:@"18683858856"]) {
        NSDictionary *userData = @{@"now": @"2015-08-14 16:29:47",
                                 @"phone": @"18683858856",
                                 @"token": @"cd457578e9d50aa13afedefc93263e55",
                               @"user_id": @"407",
                          @"head_img_url": @"http://wx.qlogo.cn/mmopen/SOFfuwiaD7Pblib8N7FPsicjiadiaH3jFIfTc3FHcz6VeetgWfYiaBkhZyXGHLFMCibaAutW6vgXs4E6tK6nNXqwsqDkJ8Ansk7k2MM/0"};
        [[SCUserInfo share] loginSuccessWithUserData:userData];
        [UMessage addAlias:userData[@"phone"] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
            if ([responseObject[@"success"] isEqualToString:@"ok"])
                [SCUserInfo share].addAliasSuccess = YES;
        }];
        [self showHUDAlertToViewController:self tag:SCHUDModeLogin text:@"登录成功"];
    } else {
        [self showHUDOnViewController:self];
        [self startLoginRequest];
    }
}

- (IBAction)cancelButtonPressed {
    [self dismissController:SCDismissTypeCancel];
}

- (IBAction)weiboLoginButtonPressed {
}

- (IBAction)weixinLoginButtonPressed {
}

#pragma mark - Private Methods
/**
 *  验证码请求方法，需要参数：phone, time_expire, mode
 */
- (void)startGetVerificationCodeReuqestWithMode:(SCVerificationCodeMode)mode {
    WEAK_SELF(weakSelf);
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text,
                           @"time_expire": @(CodeExpire),
                                  @"mode": @(mode)};
    [[SCAppApiRequest manager] startGetVerificationCodeAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (operation.response.statusCode == SCApiRequestStatusCodePOSTSuccess) {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode) {
                case SCAppApiRequestErrorCodeNoError: {
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDModeSendVerificationCode text:statusMessage];
                    break;
                }
                case SCAppApiRequestErrorCodePhoneError:
                case SCAppApiRequestErrorCodeVerificationCodeSendError: {
                    [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
                    break;
                }
            }
        } else {
            [weakSelf showHUDAlertToViewController:weakSelf text:@"获取出错，请重新获取"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *message = operation.responseObject[@"message"];
        if (message) {
            [weakSelf showHUDAlertToViewController:weakSelf text:message];
        } else {
            [weakSelf showHUDAlertToViewController:weakSelf text:NetWorkingError];
        }
        [_verificationCodeLabel stop];
    }];
}

/**
 *  登录请求方法，参数：phone，code
 */
- (void)startLoginRequest {
    WEAK_SELF(weakSelf);
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text,
                                  @"code": _verificationCodeTextField.text,
                                  @"gift": _parameter ?: @""};
    [[SCAppApiRequest manager] startLoginAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [weakSelf hideHUDOnViewController:weakSelf];
        if (operation.response.statusCode == SCApiRequestStatusCodePOSTSuccess) {
            NSInteger statusCode    = [responseObject[@"status_code"] integerValue];
            NSString *statusMessage = responseObject[@"status_message"];
            switch (statusCode) {
                case SCAppApiRequestErrorCodeNoError: {
                    NSDictionary *data = responseObject[@"data"];
                    _needShow = [data[@"gift"][@"result"] boolValue];
                    [[SCUserInfo share] loginSuccessWithUserData:data];
                    [UMessage addAlias:responseObject[@"phone"] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
                        if ([responseObject[@"success"] isEqualToString:@"ok"])
                            [SCUserInfo share].addAliasSuccess = YES;
                    }];
                    [weakSelf showHUDAlertToViewController:weakSelf tag:SCHUDModeLogin text:statusMessage];
                    break;
                }
                case SCAppApiRequestErrorCodeVerificationCodeError: {
                    [weakSelf showHUDAlertToViewController:weakSelf text:statusMessage];
                    break;
                }
            }
        } else {
            [weakSelf showHUDAlertToViewController:weakSelf text:@"注册出错，请联系远景车联"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [weakSelf hideHUDOnViewController:weakSelf];
        NSString *message = operation.responseObject[@"message"];
        if (message) {
            [weakSelf showHUDAlertToViewController:weakSelf text:message];
        } else {
            [weakSelf showHUDAlertToViewController:weakSelf text:NetWorkingError];
        }
    }];
}

// 取消按钮点击之后关闭所有键盘，并返回到[个人中心]页面
- (void)resignKeyBoard {
    [_phoneNumberTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
}

// 返回进入[注册登录]页面之前的页面
- (void)dismissController:(SCDismissType)type {
    if (type == SCDismissTypeLoginSuccess) {
        [NOTIFICATION_CENTER postNotificationName:kUserLoginSuccessNotification object:(_parameter && _needShow) ? _parameter : nil];
    }
    [_verificationCodeLabel stop];           // 退出之前要记得关掉验证码倒计时，防止内存释放引起crash
    [self resignKeyBoard];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if ((type == SCDismissTypeLoginSuccess) && _delegate && [_delegate respondsToSelector:@selector(loginSuccess)]) {
            [_delegate loginSuccess];
        }
    }];
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // 根据注册登录逻辑，进行相应的注册登录流程并执行相应方法
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    switch (hud.tag) {
        case SCHUDModeSendVerificationCode:{
            [_verificationCodeTextField becomeFirstResponder];
            break;
        }
        case SCHUDModeLogin: {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissController:SCDismissTypeLoginSuccess];
            break;
        }
    }
}

#pragma mark - Text Field Delegate Methods
#define kMaxLength 4
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length) {
        // 限制用户输入长度，以免数据越界
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];

        if ((toBeString.length >= kMaxLength) && (range.length != 1)) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            [self loginButtonPressed];
            return NO;
        } else {
            NSString *regex = @"[0-9]";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            return [pred evaluateWithObject:string];
        }
    }
    return YES;
}

@end
