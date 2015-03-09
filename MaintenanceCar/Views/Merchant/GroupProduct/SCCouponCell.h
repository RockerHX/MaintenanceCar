//
//  SCCouponCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCCoupon;

@interface SCCouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet  UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet  UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet  UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *reservationButton;

- (void)displayCellWithCoupon:(SCCoupon *)coupon;

@end
