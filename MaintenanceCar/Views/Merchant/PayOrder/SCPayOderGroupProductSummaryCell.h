//
//  SCPayOderGroupProductSummaryCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/6.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderBaseCell.h"
#import "SCGroupProduct.h"

@protocol SCPayOderGroupProductSummaryCellDelegate <NSObject>

@required
- (void)didDisplayProductPrice:(CGFloat)price;
- (void)didConfirmProductPrice:(CGFloat)price purchaseCount:(NSInteger)purchaseCount;

@end

@interface SCPayOderGroupProductSummaryCell : SCOderBaseCell

@property (weak, nonatomic) IBOutlet       id  <SCPayOderGroupProductSummaryCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet  UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet  UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *cutButton;
@property (weak, nonatomic) IBOutlet  UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

- (IBAction)cutButtonPressed;
- (IBAction)addButtonPressed;

- (CGFloat)displayCellWithProduct:(SCGroupProduct *)product;

@end
