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
#define COUNT_DOWN_TIME_DURATION    VerificationCodeTimeExpire * 10

@implementation SCVerificationCodeButton

- (void)layoutSubviews
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addObserver:self forKeyPath:kObserverKeyPath options:NSKeyValueObservingOptionNew context:nil];
    });
    
    [super layoutSubviews];
}

#pragma mark - KVO Methods
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kObserverKeyPath])
    {
        BOOL tracking = [change[NSKeyValueChangeNewKey] boolValue];
        if (tracking)
        {
            [self startCountDown];
        }
    }
}

#pragma mark - Private Methods
#pragma mark -
- (void)startCountDown
{
    __block int timeout = COUNT_DOWN_TIME_DURATION;                                                         //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, Zero);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, Zero, Zero, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, Zero), NSEC_PER_SEC * TIME_INTERVAL, Zero);            //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if(timeout <= Zero)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.enabled = YES;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self setTitle:[NSString stringWithFormat:@"%ds", timeout] forState:UIControlStateNormal];
                self.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
