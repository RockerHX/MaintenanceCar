//
//  SCADView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCADView.h"
#import "MicroCommon.h"
#import "AppDelegate.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation SCADView

#pragma mark - Init Methods
- (id)initWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCADView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    _delegate = delegate;
    
    [_imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    
    [self initConfig];
    [self viewConfig];
    
    return self;
}

#pragma mark - Action Methods
- (IBAction)enterButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldEnter)])
        [_delegate shouldEnter];
    [self removeFromSuperview];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self removeADView];
}

#pragma mark - Private Methods
- (void)initConfig
{
    self.alpha = DOT_COORDINATE;
}

- (void)viewConfig
{
    _enterButton.layer.cornerRadius = 5.0f;
    _imageView.transform            = CGAffineTransformMakeScale(0.75f, 0.75f);
    _enterButton.transform          = CGAffineTransformMakeScale(0.75f, 0.75f);
    _cancelButton.transform         = CGAffineTransformMakeScale(0.75f, 0.75f);
}

- (void)removeADView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.imageView.transform    = CGAffineTransformMakeScale(0.85f, 0.85f);
        weakSelf.enterButton.transform  = CGAffineTransformMakeScale(0.85f, 0.85f);
        weakSelf.cancelButton.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
        weakSelf.alpha                  = DOT_COORDINATE;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Public Methods
- (void)show
{
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0f;
        weakSelf.imageView.transform = CGAffineTransformIdentity;
        weakSelf.enterButton.transform = CGAffineTransformIdentity;
        weakSelf.cancelButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
