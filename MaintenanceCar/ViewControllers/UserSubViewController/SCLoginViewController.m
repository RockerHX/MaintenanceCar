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
    SCHUDModeCompareVerificationCode,
    SCHUDModeRegister,
    SCHUDModeLogin
};

@interface SCLoginViewController () <MBProgressHUDDelegate>

@property (nonatomic, copy)   NSString *verificationCode;         // 请求给用户所发送验证码，由客户端随机生成

@end

@implementation SCLoginViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)viewConfig
{
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 10.0f, 1.0f)];
    _verificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 10.0f, 1.0f)];
    
    _loginButton.layer.cornerRadius = 5.0f;
    _cancelButton.layer.cornerRadius = 5.0f;
    
    // 获取验证码View被点击之后的回调，判断是否输入手机号进行返回和执行获取验证码请求
    __weak typeof(self) weakSelf = self;
    [_verificationCodeView verificationCodeShouldSend:^BOOL{
        if ([weakSelf.phoneNumberTextField.text length])
        {
            [weakSelf startGetVerificationCodeReuqestWithMode:SCVerificationCodeModeMessage];
            return YES;
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"请输入手机号" delay:2.0f mode:SCHUDModeDefault delegate:nil];
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
    hud.mode = (mode == SCHUDModeCompareVerificationCode) ? MBProgressHUDModeIndeterminate : MBProgressHUDModeText;
    hud.yOffset = (mode == SCHUDModeCompareVerificationCode) ? DOT_COORDINATE : (SCREEN_HEIGHT/2 - 100.0f);
    hud.margin = (mode == SCHUDModeCompareVerificationCode) ? hud.margin : 10.0f;
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
                [weakSelf showPromptHUDWithText:@"验证码已发送,请注意查收" delay:1.0f mode:SCHUDModeSendVerificationCode delegate:weakSelf];
            }
            else
            {
                [weakSelf showPromptHUDWithText:@"验证码发送失败，请重新获取验证码" delay:1.0f mode:SCHUDModeDefault delegate:nil];
                [_verificationCodeView stop];
            }
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"获取出错，请重新获取" delay:1.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCFailure(@"Get verification code request error:%@", error);
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:1.0f mode:SCHUDModeDefault delegate:nil];
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
        SCFailure(@"Get verification code request error:%@", error);
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
        SCFailure(@"Get verification code request error:%@", error);
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
    [_verificationCodeView stop];
    [self resignKeyBoard];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter Methods
- (NSString *)verificationCode
{
    // 客户端生成四位数字随机验证码
    _verificationCode = [NSString stringWithFormat:@"%d", (arc4random() % 9000) + 1000];
    return _verificationCode;
}

#pragma mark - Button Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    [self resignKeyBoard];
    
    if (![_phoneNumberTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入手机号噢亲！", 1.0f);
    }
    else if (![_verificationCodeTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入验证码噢亲！", 1.0f);
    }
    else if ([_verificationCodeTextField.text isEqualToString:_verificationCode])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startRegisterRequest];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self showPromptHUDWithText:@"" delay:1.0f mode:SCHUDModeCompareVerificationCode delegate:self];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    switch (hud.tag)
    {
        case SCHUDModeSendVerificationCode:
        {
            [_verificationCodeTextField becomeFirstResponder];
        }
            break;
        case SCHUDModeCompareVerificationCode:
        {
            ShowPromptHUDWithText(self.view, @"验证码不对噢亲，请仔细检查下手机短信！", 1.0f);
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
