//
//  SCNavigationTab.m
//  NiceHome-Manager
//
//  Created by ShiCang on 15/4/13.
//  Copyright (c) 2015年 NiceHome-Manager. All rights reserved.
//

#import "SCNavigationTab.h"
#import "SCAppConstants.h"

#define AnmationDuration        0.2f

@implementation SCNavigationTab
{
    UIButton *_preButton;
}

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _anmationDuration = 0.2f;
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
    [UIView animateWithDuration:_anmationDuration animations:^{
        _line.x = button.x;
        _line.width  = button.width;
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedItemAtIndex:title:)])
        [_delegate didSelectedItemAtIndex:button.tag title:button.currentTitle];
    
    _preButton = button;
}

@end
