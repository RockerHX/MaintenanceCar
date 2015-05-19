//
//  SCOderPayGroupProductSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderPayGroupProductSummaryCell.h"
#import "SCNumberKeyBoard.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@implementation SCOderPayGroupProductSummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 43.0f;
    [SCNumberKeyBoard showWithTextField:_inputTextField];
}

#pragma mark - Action Methods
- (IBAction)enterButtonPressed
{
    [_inputTextField resignFirstResponder];
    if (_delegate && [_delegate respondsToSelector:@selector(didConfirmMerchantPrice:)])
        [_delegate didConfirmMerchantPrice:_inputTextField.text.doubleValue];
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

@end
