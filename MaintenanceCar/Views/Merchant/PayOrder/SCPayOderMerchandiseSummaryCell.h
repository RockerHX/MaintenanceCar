//
//  SCPayOderMerchandiseSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBaseCell.h"
#import "SCOderDetail.h"

@protocol SCPayOderMerchandiseSummaryCellDelegate <NSObject>

@required
- (void)didConfirmMerchantPrice:(CGFloat)price;

@end

@interface SCPayOderMerchandiseSummaryCell : SCOderBaseCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet          id  <SCPayOderMerchandiseSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet    UIButton *enterButton;

- (IBAction)enterButtonPressed;

- (CGFloat)displayCellWithDetail:(SCOderDetail *)detail;

@end
