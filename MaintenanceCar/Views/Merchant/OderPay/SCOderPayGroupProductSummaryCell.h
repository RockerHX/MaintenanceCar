//
//  SCOderPayGroupProductSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBaseCell.h"

@protocol SCOderPayGroupProductSummaryCellDelegate <NSObject>

@required
- (void)didConfirmMerchantPrice:(CGFloat)price;

@end

@interface SCOderPayGroupProductSummaryCell : SCOderBaseCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet          id  <SCOderPayGroupProductSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (IBAction)enterButtonPressed;

@end
