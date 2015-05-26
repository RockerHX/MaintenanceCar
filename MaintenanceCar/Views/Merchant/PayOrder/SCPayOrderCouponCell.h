//
//  SCPayOrderCouponCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/22.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCCoupon.h"

@protocol SCPayOrderCouponCellDelegate;

@interface SCPayOrderCouponCell : SCTableViewCell

@property (nonatomic, weak) IBOutlet       id  <SCPayOrderCouponCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet  UILabel *couponPromptLabel;

- (IBAction)checkBoxButtonPressed:(UIButton *)sender;

- (void)displayCellWithCoupons:(NSArray *)coupons index:(NSInteger)index;

@end

@protocol SCPayOrderCouponCellDelegate <NSObject>

@required
- (void)payOrderCouponCell:(SCPayOrderCouponCell *)cell selectedCoupon:(SCCoupon *)coupon;

@end
