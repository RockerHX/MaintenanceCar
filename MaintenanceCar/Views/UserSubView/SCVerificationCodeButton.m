//
//  SCVerificationCodeButton.m
//  MaintenanceCar
//
//  Created by ShiCang on 14/12/30.
//  Copyright (c) 2014年 MaintenanceCar. All rights reserved.
//

#import "SCVerificationCodeButton.h"
#import "MicroCommon.h"

#define kObserverKeyPath            @"tracking"

#define TIME_INTERVAL               1.0f
#define TIME_OUT_FLAG               1
#define COUNT_DOWN_TIME_DURATION    VerificationCodeTimeExpire * 60 + 30

@interface SCVerificationCodeButton ()
{
    NSUInteger _timeout;
    NSTimer    *_countDownTimer;
}

@end

@implementation SCVerificationCodeButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self addObserver:self forKeyPath:kObserverKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kObserverKeyPath])
    {
        BOOL tracking = [change[NSKeyValueChangeNewKey] boolValue];
        if (tracking)
        {
            self.userInteractionEnabled = NO;
            _timeout = COUNT_DOWN_TIME_DURATION;
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
    }
}

#pragma mark - Private Methods
-(void)timeFireMethod
{
    _timeout--;
    [self setTitle:[NSString stringWithFormat:@"%lus", (unsigned long)_timeout] forState:UIControlStateNormal];
    
    if(_timeout < TIME_OUT_FLAG)
    {
        [_countDownTimer invalidate];
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
    }
}

- (void)dealloc
{
    [_countDownTimer invalidate];
    [self removeObserver:self forKeyPath:kObserverKeyPath];
}

@end
