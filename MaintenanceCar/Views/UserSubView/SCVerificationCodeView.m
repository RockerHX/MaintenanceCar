//
//  SCVerificationCodeView.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/31.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCVerificationCodeView.h"
#import "MicroCommon.h"

#define TIME_OUT_FLAG               1
#define TIME_INTERVAL               1.0f
#define COUNT_DOWN_TIME_DURATION    VerificationCodeTimeExpire * 10
#define TEXT_PROMPT                 @"获取验证码"

@interface SCVerificationCodeView ()
{
    NSUInteger _timeout;
    NSTimer    *_countDownTimer;
}

@end

@implementation SCVerificationCodeView

#pragma mark - Init Methods
#pragma mark -
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startCountDown)]];
    }
    return self;
}


#pragma mark - Private Methods
#pragma mark -
- (void)startCountDown
{
    self.userInteractionEnabled = NO;
    _timeout = COUNT_DOWN_TIME_DURATION;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

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

- (void)dealloc
{
    [_countDownTimer invalidate];
}

@end
