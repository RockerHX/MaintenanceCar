//
//  SCCouponCodeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCoupon;

@protocol SCCouponCodeCellDelegate <NSObject>

@optional
- (void)couponShouldReservationWithIndex:(NSInteger)index;

@end

@interface SCCouponCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet  UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

@property (nonatomic, weak)                id  <SCCouponCodeCellDelegate>delegate;
@property (nonatomic, assign)       NSInteger  index;

- (IBAction)reservationButtonPressed:(id)sender;

- (void)displayCellWithCoupon:(SCCoupon *)coupon;

@end
