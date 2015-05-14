//
//  SCCouponCodeCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGroupCoupon.h"

@protocol SCCouponCodeCellDelegate <NSObject>

@optional
- (void)couponShouldReservationWithIndex:(NSInteger)index;
- (void)couponShouldShowWithIndex:(NSInteger)index;

@end

@interface SCCouponCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet            UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet           UIButton *reservationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reservationButtonWidith;

@property (nonatomic, weak)                id  <SCCouponCodeCellDelegate>delegate;

- (IBAction)reservationButtonPressed:(id)sender;

- (void)displayCellWithCoupon:(SCGroupCoupon *)coupon index:(NSInteger)index;

@end
