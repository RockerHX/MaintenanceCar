//
//  SCPayOrderResultCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCPayOrderResult.h"

@protocol SCPayOrderResultCellDelegate <NSObject>

@required
- (void)shouldPayForOrderWithPayment:(SCPayOrderment)payment;

@end

@interface SCPayOrderResultCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deductiblePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *weiXinPayButton;
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;

@property (nonatomic, weak) IBOutlet id  <SCPayOrderResultCellDelegate>delegate;

- (IBAction)weiXinPayBUttonPressed;
- (IBAction)aliPayButtonPressed;

- (void)displayCellWithResult:(SCPayOrderResult *)result;

@end
