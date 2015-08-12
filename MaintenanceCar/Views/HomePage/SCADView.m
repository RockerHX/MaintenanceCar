//
//  SCADView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCADView.h"
#import "UIConstants.h"
#import "MicroConstants.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation SCADView

#pragma mark - Init Methods
#pragma clang diagnostic ignored "-Wunused-variable"
+ (void)showWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL {
    SCADView *adView = [[SCADView alloc] initWithDelegate:delegate imageURL:imageURL];
}

- (instancetype)initWithDelegate:(id<SCADViewDelegate>)delegate imageURL:(NSString *)imageURL {
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCADView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    _delegate = delegate;
    
    __weak __typeof(self)weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf show];
    }];
    
    [self initConfig];
    [self viewConfig];
    
    return self;
}

#pragma mark - Action Methods
- (IBAction)cancelButtonPressed {
    [self removeADView];
}

#pragma mark - Private Methods
- (void)initConfig {
    self.alpha = ZERO_POINT;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)viewConfig {
    _imageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    _cancelButton.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
}

- (void)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(shouldEnter)]) {
        [_delegate shouldEnter];
    }
    [self removeFromSuperview];
}

- (void)removeADView {
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:0.2f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.imageView.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
        weakSelf.cancelButton.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
        weakSelf.alpha = ZERO_POINT;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Public Methods
- (void)show {
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:0.3f delay:ZERO_POINT options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.alpha = 1.0f;
        weakSelf.imageView.transform = CGAffineTransformIdentity;
        weakSelf.cancelButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

@end
