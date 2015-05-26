//
//  SCPayOrderGroupProductSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderBaseCell.h"
#import "SCGroupProduct.h"

@protocol SCPayOrderGroupProductSummaryCellDelegate <NSObject>

@required
- (void)didConfirmProductPrice:(CGFloat)price purchaseCount:(NSInteger)purchaseCount;

@end

@interface SCPayOrderGroupProductSummaryCell : SCOrderBaseCell

@property (weak, nonatomic) IBOutlet       id  <SCPayOrderGroupProductSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet  UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet  UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cutButton;
@property (weak, nonatomic) IBOutlet  UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)cutButtonPressed;
- (IBAction)addButtonPressed;

- (void)displayCellWithProduct:(SCGroupProduct *)product;

@end
