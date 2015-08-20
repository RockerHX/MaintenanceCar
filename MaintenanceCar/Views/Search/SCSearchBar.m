//
//  SCSearchBar.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/7/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSearchBar.h"

@implementation SCSearchBar

#pragma mark - Init Methods
- (void)awakeFromNib {
    [_textField becomeFirstResponder];
}

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    _fieldView.layer.cornerRadius = 2.0f;
}

#pragma mark - Action Methods
- (IBAction)backButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldBackReturn)])
        [_delegate shouldBackReturn];
}

- (IBAction)searchButtonPressed
{
    [self packUpKeyBoard];
}

#pragma mark - Private Methods
- (void)packUpKeyBoard
{
    [_textField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(shouldSearchWithContent:)])
        [_delegate shouldSearchWithContent:_textField.text];
}

#pragma mark - Text Field Delegaet Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self packUpKeyBoard];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldResearch)])
        [_delegate shouldResearch];
}

@end