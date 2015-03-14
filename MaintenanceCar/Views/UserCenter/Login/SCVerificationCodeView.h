//
//  SCVerificationCodeView.h
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/31.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCVerificationCodeView : UILabel

/**
 *  点击事件回调方法 - 当SCVerificationCodeView被点击的时候，触发此回调
 *
 *  @param block 执行代码
 */
- (void)verificationCodeShouldSend:(BOOL(^)())block;

/**
 *  停止计时，用于网络信号不好等时候无法获取验证码的时候，重新获取验证码
 */
- (void)stop;

@end