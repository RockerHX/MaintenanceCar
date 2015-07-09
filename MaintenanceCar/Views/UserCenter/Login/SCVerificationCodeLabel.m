//
//  SCVerificationCodeLabel.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/31.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCVerificationCodeLabel.h"
#import "AppMicroConstants.h"

typedef BOOL(^BLOCK)(void);

#define TIME_OUT_FLAG               1                                       // 倒计时结束时间
#define TIME_INTERVAL               1.0f                                    // 倒计时时间间隔
#define COUNT_DOWN_TIME_DURATION    CodeExpire * 60 + 30                    // 倒计时结束时间
#define TEXT_PROMPT                 @"获取语音验证码"                         // SCVerificationCodeView提示

@implementation SCVerificationCodeLabel
{
    BLOCK      _block;                  // 点击事件回调函数
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    // 加入一个单击手势，事件触发关联到startCountDown方法
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCountDown)]];
}

#pragma mark - Private Methods
- (void)startCountDown
{
    // 如果回调获得的返回值为YES，执行倒计时
    if(_block())
    {
        self.userInteractionEnabled = NO;
        _timeout = COUNT_DOWN_TIME_DURATION;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
}

/**
 *  倒计时刷新方法
 */
- (void)timeFireMethod
{
    _timeout--;
    self.text = [NSString stringWithFormat:@"%@s", @(_timeout)];
    
    if(_timeout < TIME_OUT_FLAG)
    {
        [self stop];
    }
}

#pragma mark - Public Methods
- (void)codeShouldSend:(BOOL(^)())block
{
    _block = block;
}

- (void)stop
{
    [_countDownTimer invalidate];
    
    self.text = TEXT_PROMPT;
    self.userInteractionEnabled = YES;
}

#pragma mark - Delloc Methods
- (void)dealloc
{
    // 如果View被移除，定时器需要废除掉
    [_countDownTimer invalidate];
}

@end
