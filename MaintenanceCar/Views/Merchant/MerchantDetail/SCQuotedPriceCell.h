//
//  SCQuotedPriceCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCQuotedPriceCellDelegate <NSObject>

@optional
- (void)shouldSpecialReservation;

@end

@class SCQuotedPrice;

@interface SCQuotedPriceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet  UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet  UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

@property (nonatomic, weak)                id  <SCQuotedPriceCellDelegate>delegate;
@property (nonatomic, assign)       NSInteger  index;

- (IBAction)reservationButtonPressed:(id)sender;

- (void)displayCellWithProduct:(SCQuotedPrice *)product;

@end
