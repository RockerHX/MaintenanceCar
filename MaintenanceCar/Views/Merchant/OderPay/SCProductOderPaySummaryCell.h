//
//  SCProductOderPaySummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"

//@protocol SCProductOderPaySummaryCellDelegate <NSObject>
//
//@required
//- (void)didConfirmMerchantPrice:(CGFloat)price;
//
//@end

@interface SCProductOderPaySummaryCell : SCOderCell

//@property (weak, nonatomic) IBOutlet          id  <SCProductOderPaySummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

- (IBAction)enterButtonPressed;

@end
