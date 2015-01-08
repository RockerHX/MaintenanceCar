//
//  SCReservatAlertView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/8.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCReservatAlertView.h"
#import "MicroCommon.h"
#import "AppDelegate.h"

@interface SCReservatAlertView ()

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *titleView;

- (IBAction)cancelButtonPressed:(UIButton *)sender;
- (IBAction)itemPressed:(UIButton *)sender;

@end

@implementation SCReservatAlertView

- (id)initWithDelegate:(id<SCReservatAlertViewDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCReservatAlertView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    
    _delegate = delegate;
    self.alpha = DOT_COORDINATE;
    _alertView.hidden = YES;
    _alertView.layer.cornerRadius = 8.0f;
    _titleView.layer.cornerRadius = _alertView.layer.cornerRadius;
    _alertView.layer.borderWidth = 1.0f;
    _alertView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:.2f].CGColor;
    return self;
}

#pragma mark - Private Methods
#pragma mark -
- (void)removeAlertView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.alpha = DOT_COORDINATE;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Action Methods
#pragma mark -
- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self removeAlertView];
}

- (IBAction)itemPressed:(UIButton *)sender
{
    [_delegate selectedAtButton:sender.tag];
    [self removeAlertView];
}

#pragma mark - Public Methods
#pragma mark -
- (void)show
{
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _alertView.hidden = NO;
            _alertView.transform = CGAffineTransformMakeScale(0.7f, 0.7f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _alertView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    _alertView.transform = CGAffineTransformIdentity;
                }];
            }];
        }];
    }];
}

@end
