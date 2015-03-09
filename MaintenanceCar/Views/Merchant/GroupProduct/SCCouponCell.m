//
//  SCCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCell.h"
#import "SCCoupon.h"

@implementation SCCouponCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _reservationButton.layer.cornerRadius = 3.0f;
    _reservationButton.layer.borderWidth  = 1.0f;
    _reservationButton.layer.borderColor  = [UIColor orangeColor].CGColor;
}

#pragma mark - Public Methods
- (void)displayCellWithCoupon:(SCCoupon *)coupon
{
    _merchantNameLabel.text = coupon.company_name;
    _productNameLabel.text = coupon.title;
    _couponPriceLabel.text = coupon.final_price;
    _productPriceLabel.text = coupon.total_price;
    _codeLabel.text = coupon.code;
}

@end
