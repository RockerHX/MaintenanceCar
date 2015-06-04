//
//  SCOrderDetailPayCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@class SCOrderDetail;

@protocol SCOrderDetailPayCellDelegate <NSObject>

@optional
- (void)userWantToPayForOrder;

@end

@interface SCOrderDetailPayCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet       id  <SCOrderDetailPayCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet  UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet  UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet  UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *payOrderButton;

- (IBAction)payOrderButtonPressed;

- (void)displayCellWithDetail:(SCOrderDetail *)detail;

@end
