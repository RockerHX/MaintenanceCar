//
//  SCPayOderMerchandiseSummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCPayOderMerchandiseSummaryCell.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <SCNumberKeyBoard/SCNumberKeyBoard.h>

@implementation SCPayOderMerchandiseSummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _enterButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _enterButton.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    _enterButton.layer.shadowOpacity = 1.0f;
    _enterButton.layer.shadowRadius = 1.0f;
    
    __weak typeof(self)weakSelf = self;
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 43.0f;
    [SCNumberKeyBoard showWithTextField:_inputTextField block:^(NSString *number) {
        [weakSelf executeDelegateMethodWithNumber:number];
    }];
}

#pragma mark - Action Methods
- (IBAction)enterButtonPressed
{
    [_inputTextField resignFirstResponder];
    [self executeDelegateMethodWithNumber:_inputTextField.text];
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithDetail:(SCOderDetail *)detail
{
    self.carModelLabel.text     = detail.carModelName;
    self.serviceNameLabel.text  = detail.serviceName;
    self.merchantNameLabel.text = detail.merchantName;
    return [self layoutSizeFittingSize];
}

#pragma mark - Private Methods
- (void)executeDelegateMethodWithNumber:(NSString *)number
{
    if (_delegate && [_delegate respondsToSelector:@selector(didConfirmMerchantPrice:)])
        [_delegate didConfirmMerchantPrice:number.doubleValue];
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
