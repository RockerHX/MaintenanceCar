//
//  SCProductOderPaySummaryCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCProductOderPaySummaryCell.h"

@implementation SCProductOderPaySummaryCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    self.merchantNameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 23.0f;
}

#pragma mark - Action Methods
- (IBAction)enterButtonPressed
{
//    if (_delegate && [_delegate respondsToSelector:@selector(didConfirmMerchantPrice:)])
//        [_delegate didConfirmMerchantPrice:_inputTextField.text.doubleValue];
}

@end
