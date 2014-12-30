//
//  SCLoginViewController.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/29.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;

- (IBAction)verificationCodeButtonPressed:(UIButton *)sender;
- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)weiboLoginButtonPressed:(UIButton *)sender;
- (IBAction)weixinLoginButtonPressed:(UIButton *)sender;

@end
