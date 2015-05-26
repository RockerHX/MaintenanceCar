//
//  SCPayOrderMerchandiseSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBaseCell.h"
#import "SCOrderDetail.h"

@protocol SCPayOrderMerchandiseSummaryCellDelegate <NSObject>

@required
- (void)didConfirmMerchantPrice:(CGFloat)price;

@end

@interface SCPayOrderMerchandiseSummaryCell : SCOrderBaseCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet          id  <SCPayOrderMerchandiseSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet      UIView *paySuccessView;
@property (weak, nonatomic) IBOutlet     UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet    UIButton *enterButton;

- (IBAction)enterButtonPressed;

- (void)displayCellWithDetail:(SCOrderDetail *)detail;

@end
