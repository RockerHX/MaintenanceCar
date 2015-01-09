//
//  SCDatePickerView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDatePickerView.h"
#import "MicroCommon.h"
#import "AppDelegate.h"

@implementation SCDatePickerView

- (id)initWithDelegate:(id<SCDatePickerViewDelegate>)delegate mode:(UIDatePickerMode)mode
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCDatePickerView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    
    _delegate = delegate;
    _datePicker.datePickerMode = mode;
    _datePicker.minimumDate = [NSDate date];
    
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self viewConfig];
    
    return self;
}

#pragma mark - Private Methods
#pragma mark -
- (void)viewConfig
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGestureRecognizer)]];
    self.alpha = DOT_COORDINATE;
}

-(void)dateChanged:(UIDatePicker *)datePicker
{
    [_delegate datePickerSelectedFinish:datePicker.date mode:_datePicker.datePickerMode];
}

- (void)addGestureRecognizer
{
    [_delegate datePickerSelectedFinish:_datePicker.date mode:_datePicker.datePickerMode];
    [self removeDatePickerView];
}

- (void)removeDatePickerView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.alpha = DOT_COORDINATE;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Public Methods
#pragma mark -
- (void)show
{
    __weak typeof(self) weakSelf = self;
    [APP_DELEGATE_INSTANCE.window addSubview:self];
    _bottomConstraint.constant = _bottomConstraint.constant / 8;
    [_containerView needsUpdateConstraints];
    [UIView animateWithDuration:0.15f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseIn animations:^{
        weakSelf.alpha = 0.2f;
        [weakSelf.containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        _bottomConstraint.constant = DOT_COORDINATE;
        [_containerView needsUpdateConstraints];
        [UIView animateWithDuration:0.15f delay:DOT_COORDINATE options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.alpha = 1.0f;
            [weakSelf.containerView layoutIfNeeded];
        } completion:nil];
    }];
}

@end
