//
//  SCLoginViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MicroCommon.h"
#import "SCAPIRequest.h"
#import "SCUserInfo.h"
#import "SCVerificationCodeView.h"

typedef NS_ENUM(NSInteger, SCVerificationCodeMode) {
    SCVerificationCodeModeMessage = 1,          // 短信验证模式
    SCVerificationCodeModeCall                  // 语音验证模式
};

typedef NS_ENUM(NSInteger, SCHUDMode) {
    SCHUDModeDefault = 1,
    SCHUDModeSendVerificationCode,
    SCHUDModeRegister,
    SCHUDModeLogin
};

@interface SCLoginViewController () <MBProgressHUDDelegate>

@property (nonatomic, copy)   NSString *verificationCode;         // 请求给用户所发送验证码，由客户端随机生成

@end

@implementation SCLoginViewController

#pragma mark - View Controller Life Cycle
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    // 获取验证码视图被点击之后的回调，判断是否输入手机号进行返回和执行获取验证码请求
    [_verificationCodeView verificationCodeShouldSend:^BOOL{
        if ([_phoneNumberTextField.text length])
        {
            [self startGetVerificationCodeReuqestWithMode:SCVerificationCodeModeMessage];
            return YES;
        }
        else
        {
            [self showPromptHUDWithText:@"请输入手机号" delay:2.0f mode:SCHUDModeDefault delegate:nil];
            return NO;
        }
    }];
}

/**
 *  用户提示方法
 *
 *  @param text     提示内容
 *  @param delay    提示消失时间
 *  @param delegate 代理对象
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay mode:(SCHUDMode)mode delegate:(id<MBProgressHUDDelegate>)delegate
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = mode;
    hud.delegate = delegate;
    hud.mode = MBProgressHUDModeText;
    hud.yOffset = SCREEN_HEIGHT/2 - 100.0f;
    hud.margin = 10.f;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:delay];
}

/**
 *  验证码请求方法，需要参数：phone, code, time_expire, mode
 */
- (void)startGetVerificationCodeReuqestWithMode:(SCVerificationCodeMode)mode
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"phone"      : _phoneNumberTextField.text,
                                 @"code"       : self.verificationCode,
                                 @"time_expire": @(VerificationCodeTimeExpire),
                                 @"mode"       : @(mode)};
    [[SCAPIRequest manager] startGetVerificationCodeAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            if ([[responseObject objectForKey:@"msg"] isEqualToString:@"OK"])
            {
                [weakSelf showPromptHUDWithText:@"验证码已发送,请注意查收" delay:2.0f mode:SCHUDModeSendVerificationCode delegate:weakSelf];
            }
            else
            {
                [weakSelf showPromptHUDWithText:@"验证码发送失败，请重新获取验证码" delay:2.0f mode:SCHUDModeDefault delegate:nil];
                [_verificationCodeView stop];
            }
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"获取出错，请重新获取" delay:2.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"Get verification code request error:%@", error);
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:2.0f mode:SCHUDModeDefault delegate:nil];
    }];
}

/**
 *  注册请求方法，需要参数：phone
 */
- (void)startRegisterRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text};
    [[SCAPIRequest manager] startRegisterAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [weakSelf startLoginRequest];
        }
        else if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [SCUserInfo loginSuccessWithUserID:responseObject];
            [weakSelf showPromptHUDWithText:@"注册成功" delay:1.0f mode:SCHUDModeRegister delegate:weakSelf];
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"注册出错，请联系远景车联" delay:2.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"Get verification code request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:2.0f mode:SCHUDModeDefault delegate:nil];
    }];
}

- (void)startLoginRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text};
    [[SCAPIRequest manager] startLoginAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [SCUserInfo loginSuccessWithUserID:responseObject];
            [weakSelf showPromptHUDWithText:@"登陆成功" delay:1.0f mode:SCHUDModeLogin delegate:weakSelf];
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"注册出错，请联系远景车联" delay:2.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"Get verification code request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:2.0f mode:SCHUDModeDefault delegate:nil];
    }];
}

- (void)resignKeyBoard
{
    // 取消按钮点击之后关闭所有键盘，并返回到[个人中心]页面
    [_phoneNumberTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
}

- (void)dismissController
{
    [self resignKeyBoard];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)verificationCode
{
    // 客户端生成四位数字随机验证码
    _verificationCode = [NSString stringWithFormat:@"%d", (arc4random() % 9000) + 1000];
    return _verificationCode;
}

#pragma mark - Button Action Methods
#pragma mark -
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self resignKeyBoard];
    if ([_verificationCodeTextField.text isEqualToString:_verificationCode])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startRegisterRequest];
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self dismissController];
}

- (IBAction)weiboLoginButtonPressed:(UIButton *)sender
{
}

- (IBAction)weixinLoginButtonPressed:(UIButton *)sender
{
}

#pragma mark - Touch Event Methods
#pragma makr -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - MBProgressHUDDelegate Methods
#pragma mark -
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    switch (hud.tag)
    {
        case SCHUDModeSendVerificationCode:
        {
            [_verificationCodeTextField becomeFirstResponder];
        }
            break;
        case SCHUDModeRegister:
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissController];
        }
            break;
        case SCHUDModeLogin:
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self dismissController];
        }
            break;
            
        default:
            break;
    }
}

@end
