//
//  SCNavigationTab.m
//  NiceHome-Manager
//
//  Created by ShiCang on 15/4/13.
//  Copyright (c) 2015年 NiceHome-Manager. All rights reserved.
//

#import "SCNavigationTab.h"
#import "AppMicroConstants.h"

@implementation SCNavigationTab
{
    UIButton *_preButton;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _preButton = _firstButton;
}

#pragma mark - Action Methods
- (IBAction)firstButtonPressed:(UIButton *)button
{
    [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    
    button.tag = 0;
    [self buttonPressedWithButton:button];
}

- (IBAction)secondButtonPressed:(UIButton *)button
{
    [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    
    button.tag = 1;
    [self buttonPressedWithButton:button];
}

- (IBAction)thirdButtonPressed:(UIButton *)button
{
    [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    
    button.tag = 2;
    [self buttonPressedWithButton:button];
}

- (IBAction)fourthButtonPressed:(UIButton *)button
{
    [button setTitleColor:ThemeColor forState:UIControlStateNormal];
    
    button.tag = 3;
    [self buttonPressedWithButton:button];
}

#pragma mark - Private Methods
- (void)buttonPressedWithButton:(UIButton *)button
{
    [_preButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        _line.x = button.x;
        _line.width  = button.width;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItemAtIndex:)])
        [_delegate didSelectedItemAtIndex:button.tag];
    
    _preButton = button;
}

@end
