//
//  SCPayOderResultCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCPayOderResult.h"

@protocol SCPayOderResultCellDelegate <NSObject>

@required
- (void)shouldPayForOderWithPayment:(SCPayOderment)payment;

@end

@interface SCPayOderResultCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deductiblePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *weiXinPayButton;
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;

@property (nonatomic, weak) IBOutlet id  <SCPayOderResultCellDelegate>delegate;

- (IBAction)weiXinPayBUttonPressed;
- (IBAction)aliPayButtonPressed;

- (CGFloat)displayCellWithResult:(SCPayOderResult *)result;

@end
