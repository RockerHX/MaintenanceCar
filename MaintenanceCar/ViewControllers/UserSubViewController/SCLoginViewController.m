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
#import "SCVerificationCodeView.h"

typedef NS_ENUM(NSInteger, SCVerificationCodeMode) {
    SCVerificationCodeModeMessage = 1,          // 短信验证模式
    SCVerificationCodeModeCall                  // 语音验证模式
};

@interface SCLoginViewController () <UITextFieldDelegate>

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
            [self showPromptHUDWithText:@"请输入手机号" delay:2.0f];
            return NO;
        }
    }];
}

/**
 *  用户提示方法
 *
 *  @param text  提示内容
 *  @param delay 提示消失时间
 */
- (void)showPromptHUDWithText:(NSString *)text delay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
    NSDictionary *parameters = @{@"phone"      : _phoneNumberTextField.text,
                                 @"code"       : self.verificationCode,
                                 @"time_expire": @(VerificationCodeTimeExpire),
                                 @"mode"       : @(mode)};
    [[SCAPIRequest manager] startGetVerificationCodeAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [self showPromptHUDWithText:@"短信已发送" delay:2.0f];
        }
        else
        {
            [self showPromptHUDWithText:@"获取出错，请重新获取" delay:2.0f];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"Get verification code request error:%@", error);
        [self showPromptHUDWithText:@"获取出错，请重新获取" delay:2.0f];
    }];
}

/**
 *  注册请求方法，需要参数：phone
 */
- (void)startRegisterRequest
{
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text};
    [[SCAPIRequest manager] startRegisterAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Getter Methods
#pragma mark -
- (NSString *)verificationCode
{
    // 客户端生成四位数字随机验证码
    return [NSString stringWithFormat:@"%d", (arc4random() % 9000) + 1000];
}

#pragma mark - Button Action Methods
#pragma mark -
- (IBAction)loginButtonPressed:(UIButton *)sender
{
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    // 取消按钮点击之后关闭所有键盘，并返回到[个人中心]页面
    [_phoneNumberTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)weiboLoginButtonPressed:(UIButton *)sender
{
}

- (IBAction)weixinLoginButtonPressed:(UIButton *)sender
{
}

#pragma mark - Text Field Delegate Methods
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 关闭键盘
    [textField resignFirstResponder];
    return YES;
}

@end
