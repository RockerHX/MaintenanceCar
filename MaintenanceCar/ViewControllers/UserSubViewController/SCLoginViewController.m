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

typedef NS_ENUM(NSInteger, SCVerificationCodeMode) {
    SCVerificationCodeModeMessage = 1,          // 短信验证模式
    SCVerificationCodeModeCall                  // 语音验证模式
};

@interface SCLoginViewController () <UITextFieldDelegate>

@property (nonatomic, assign) SCVerificationCodeMode verificationCodeMode;
@property (nonatomic, copy)   NSString               *verificationCode;

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
    // 验证码默认采取短信验证
    _verificationCodeMode = SCVerificationCodeModeMessage;
}

- (void)startGetVerificationCodeReuqest
{
    NSDictionary *parameters = @{@"phone"      : _phoneNumberTextField.text,
                                 @"code"       : self.verificationCode,
                                 @"time_expire": @(VerificationCodeTimeExpire),
                                 @"mode"       : @(_verificationCodeMode)};
    [[SCAPIRequest manager] startGetVerificationCodeAPIRequestWithParameters:parameters Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (operation.response.statusCode == SCAPIRequestStatusCodePOSTSuccess)
        {
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SCError(@"Get verification code request error:%@", error);
    }];
}

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
    return [NSString stringWithFormat:@"%d", (arc4random() % 9000) + 1000];
}

#pragma mark - Button Action Methods
#pragma mark -
- (IBAction)verificationCodeButtonPressed:(UIButton *)sender
{
//    [self startGetVerificationCodeReuqest];
}

- (IBAction)loginButtonPressed:(UIButton *)sender
{
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [_phoneNumberTextField resignFirstResponder];
    [_verificationCodeTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [textField resignFirstResponder];
    return YES;
}

@end
