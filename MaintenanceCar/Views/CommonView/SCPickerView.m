//
//  SCPickerView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPickerView.h"
#import "MicroCommon.h"
#import "AppDelegate.h"

#define ReservationItemsResourceName    @"ReservationItems"
#define ReservationItemsResourceType    @"plist"

@interface SCPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray  *_pickerItmes;
    NSString *_item;
}

@end

@implementation SCPickerView

- (id)initWithDelegate:(id<SCPickerViewDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SCPickerView" owner:self options:nil] firstObject];
    self.frame = APP_DELEGATE_INSTANCE.window.bounds;
    
    _picker.dataSource = self;
    _picker.delegate = self;
    _delegate = delegate;
    _pickerItmes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:ReservationItemsResourceName ofType:ReservationItemsResourceType]];
    
    [self viewConfig];
    
    return self;
}

#pragma mark - Picker View Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerItmes.count;
}

#pragma mark - Picker View Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerItmes[row][DisplayNameKey];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    @try {
        _item = _pickerItmes[row][DisplayNameKey];
    }
    @catch (NSException *exception) {
        SCException(@"SCPickerView Get Item Error:%@", exception.reason);
    }
    @finally {
    }
}

#pragma mark - Private Methods
- (void)viewConfig
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGestureRecognizer)]];
    self.alpha = DOT_COORDINATE;
}

- (void)addGestureRecognizer
{
    @try {
        [_delegate pickerViewSelectedFinish:_item ? _item : _pickerItmes[0][RequestValueKey]
                                displayName:_item ? _item : _pickerItmes[0][DisplayNameKey]];
    }
    @catch (NSException *exception) {
        SCException(@"SCPickerView Return Item Error:%@", exception.reason);
    }
    @finally {
        [self removePickerView];
    }
}

- (void)removePickerView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.alpha = DOT_COORDINATE;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Public Methods
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
