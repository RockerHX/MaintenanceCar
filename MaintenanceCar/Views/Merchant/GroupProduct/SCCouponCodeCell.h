//
//  SCCouponCodeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCoupon;

@interface SCCouponCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet  UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

- (IBAction)reservationButtonPressed:(id)sender;

- (void)displayCellWithCoupon:(SCCoupon *)coupon;

@end
