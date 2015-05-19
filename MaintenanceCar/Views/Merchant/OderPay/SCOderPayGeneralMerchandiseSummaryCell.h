//
//  SCOderPayGeneralMerchandiseSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBaseCell.h"

@protocol SCOderPayGeneralMerchandiseSummaryCellDelegate <NSObject>

@required
- (void)didConfirmMerchantPrice:(CGFloat)price;

@end

@interface SCOderPayGeneralMerchandiseSummaryCell : SCOderBaseCell

@property (weak, nonatomic) IBOutlet       id  <SCOderPayGeneralMerchandiseSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet  UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet  UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cutButton;
@property (weak, nonatomic) IBOutlet  UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)cutButtonPressed;
- (IBAction)addButtonPressed;

@end
