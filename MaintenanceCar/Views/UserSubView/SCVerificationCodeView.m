//
//  SCVerificationCodeView.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/31.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCVerificationCodeView.h"
#import "MicroCommon.h"

typedef BOOL(^BLOCK)(void);

#define TIME_OUT_FLAG               1                                       // 倒计时结束时间
#define TIME_INTERVAL               1.0f                                    // 倒计时时间间隔
#define COUNT_DOWN_TIME_DURATION    VerificationCodeTimeExpire * 60 + 30    // 倒计时结束时间
#define TEXT_PROMPT                 @"获取验证码"                             // SCVerificationCodeView提示

@interface SCVerificationCodeView ()
{
    NSUInteger _timeout;                // 倒计时结束时间
    NSTimer    *_countDownTimer;        // 倒计时计时器
    BLOCK      _block;                  // 点击事件回调函数
}

@end

@implementation SCVerificationCodeView

#pragma mark - Init Methods
#pragma mark -
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // 加入一个单击手势，事件触发关联到startCountDown方法
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCountDown)]];
    }
    return self;
}


#pragma mark - Private Methods
#pragma mark -
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
-(void)timeFireMethod
{
    _timeout--;
    self.text = [NSString stringWithFormat:@"%lus", (unsigned long)_timeout];
    
    if(_timeout < TIME_OUT_FLAG)
    {
        [_countDownTimer invalidate];
        
        self.text = TEXT_PROMPT;
        self.userInteractionEnabled = YES;
    }
}

#pragma mark - Public Methods
#pragma mark -
- (void)verificationCodeShouldSend:(BOOL(^)())block
{
    _block = block;
}

#pragma mark - Delloc Methods
#pragma mark -
- (void)dealloc
{
    // 如果视图被移除，定时器需要废除掉
    [_countDownTimer invalidate];
}

@end
