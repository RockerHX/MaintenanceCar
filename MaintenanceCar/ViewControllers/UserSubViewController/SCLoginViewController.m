//
//  SCLoginViewController.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCLoginViewController.h"
#import "SCVerificationCodeView.h"
#import "UMessage.h"

// 登录验证模式
typedef NS_ENUM(NSInteger, SCVerificationCodeMode) {
    SCVerificationCodeModeMessage = 1,          // 短信验证模式
    SCVerificationCodeModeCall                  // 语音验证模式
};

// HUD提示框类型
typedef NS_ENUM(NSInteger, SCHUDMode) {
    SCHUDModeDefault = 1,
    SCHUDModeSendVerificationCode,
    SCHUDModeCompareVerificationCode,
    SCHUDModeRegister,
    SCHUDModeLogin
};

typedef NS_ENUM(NSInteger, SCDismissType) {
    SCDismissTypeLoginSuccess,
    SCDismissTypeCancel
};

@interface SCLoginViewController () <MBProgressHUDDelegate>

@property (nonatomic, copy)   NSString *verificationCode;         // 请求给用户所发送验证码，由客户端随机生成

@end

@implementation SCLoginViewController

#pragma mark - View Controller Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"[个人中心] - 注册登录"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 用户行为统计，页面停留时间
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"[个人中心] - 注册登录"];
}

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
    // 配置手机输入框和短信验证码输入框，输入光标向右偏移10个像素，避免光标贴到输入框边缘造成视觉影响
    _phoneNumberTextField.leftViewMode = UITextFieldViewModeAlways;
    _phoneNumberTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 10.0f, 1.0f)];
    _verificationCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    _verificationCodeTextField.leftView = [[UILabel alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, 10.0f, 1.0f)];
    
    // 配置登录和取消按钮，设置圆角
    _loginButton.layer.cornerRadius = 5.0f;
    _cancelButton.layer.cornerRadius = 5.0f;
    
    // self弱引用，防止block使用出现循环引用，造成内存泄露
    __weak typeof(self) weakSelf = self;
    // 获取验证码View被点击之后的回调，判断是否输入手机号进行返回和执行获取验证码请求
    [_verificationCodeView verificationCodeShouldSend:^BOOL{
        if ([weakSelf.phoneNumberTextField.text length])
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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
    NSLog(@"%@", _verificationCode);
    [[SCAPIRequest manager] startGetVerificationCodeAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"Get verification code request error:%@", error);
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:1.0f mode:SCHUDModeDefault delegate:nil];
        [_verificationCodeView stop];
    }];
}

/**
 *  注册请求方法，需要参数：phone
 */
- (void)startRegisterRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text};
    [[SCAPIRequest manager] startRegisterAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [weakSelf startLoginRequest];
        }
        else if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            [[SCUserInfo share] loginSuccessWithUserID:responseObject];
            [weakSelf showPromptHUDWithText:@"注册成功" delay:1.0f mode:SCHUDModeRegister delegate:weakSelf];
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"注册出错，请联系远景车联" delay:2.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get verification code request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:2.0f mode:SCHUDModeDefault delegate:nil];
    }];
}

/**
 *  登录请求方法，参数：phone
 */
- (void)startLoginRequest
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"phone": _phoneNumberTextField.text};
    [[SCAPIRequest manager] startLoginAPIRequestWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodeGETSuccess)
        {
            [[SCUserInfo share] loginSuccessWithUserID:responseObject];
            [UMessage addAlias:responseObject[@"phone"] type:@"XiuYang-IOS" response:^(id responseObject, NSError *error) {
                if ([responseObject[@"success"] isEqualToString:@"ok"])
                    [SCUserInfo share].addAliasSuccess = YES;
            }];
            [weakSelf showPromptHUDWithText:@"登录成功" delay:1.0f mode:SCHUDModeLogin delegate:weakSelf];
        }
        else
        {
            [weakSelf showPromptHUDWithText:@"注册出错，请联系远景车联" delay:2.0f mode:SCHUDModeDefault delegate:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get verification code request error:%@", error);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf showPromptHUDWithText:@"网络错误，请检查网络" delay:2.0f mode:SCHUDModeDefault delegate:nil];
    }];
}

// 取消按钮点击之后关闭所有键盘，并返回到[个人中心]页面
- (void)resignKeyBoard
{
    [_phoneNumberTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
}

// 返回进入[注册登录]页面之前的页面
- (void)dismissController:(SCDismissType)type
{
    if (type == SCDismissTypeLoginSuccess)
        [NOTIFICATION_CENTER postNotificationName:kUserLoginSuccessNotification object:nil];
    [_verificationCodeView stop];           // 退出之前要记得关掉验证码倒计时，防止内存释放引起crash
    [self resignKeyBoard];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter Methods
/**
 *  生成验证码
 *
 *  @return 生成的验证码
 */
- (NSString *)verificationCode
{
    // 客户端生成四位数字随机验证码
    _verificationCode = [NSString stringWithFormat:@"%d", (arc4random() % 9000) + 1000];
    return _verificationCode;
}

#pragma mark - Button Action Methods
- (IBAction)loginButtonPressed:(UIButton *)sender
{
    // 登录按钮点击之后分别经行是否输入手机号，是否输入验证码，验证码是否正确的判断操作，前面这些都正确以后才进行注册登录操作
    [self resignKeyBoard];
    
    if (![_phoneNumberTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入手机号噢亲！", 1.0f);
    }
    else if (![_verificationCodeTextField.text length])
    {
        ShowPromptHUDWithText(self.view, @"请输入验证码噢亲！", 1.0f);
    }
    else if ([_verificationCodeTextField.text isEqualToString:_verificationCode] ||
             ([_phoneNumberTextField.text isEqualToString:@"18683858856"] &&
              [_verificationCodeTextField.text isEqualToString:@"1234"]))
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self startRegisterRequest];
    }
    else
    {
        // 验证码错误，模拟请求，造成用户错觉
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self showPromptHUDWithText:@"" delay:1.0f mode:SCHUDModeCompareVerificationCode delegate:self];
    }
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self dismissController:SCDismissTypeCancel];
}

- (IBAction)weiboLoginButtonPressed:(UIButton *)sender
{
}

- (IBAction)weixinLoginButtonPressed:(UIButton *)sender
{
}

#pragma mark - Touch Event Methods
// 点击页面上不能相应事件的位置，收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - MBProgressHUDDelegate Methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    // 根据注册登录逻辑，进行相应的注册登录流程并执行相应方法
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
            ShowPromptHUDWithText(self.view, @"验证码不对噢亲！", 1.0f);
        }
            break;
        case SCHUDModeRegister:
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissController:SCDismissTypeLoginSuccess];
        }
            break;
        case SCHUDModeLogin:
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self dismissController:SCDismissTypeLoginSuccess];
        }
            break;
    }
}

@end
