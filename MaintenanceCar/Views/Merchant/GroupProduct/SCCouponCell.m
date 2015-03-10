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

#pragma mark - Public Methods
- (void)displayCellWithCoupon:(SCCoupon *)coupon
{
    [super displayCellWithCoupon:coupon];
    
    _merchantNameLabel.text = coupon.company_name;
    _productNameLabel.text = coupon.title;
    _couponPriceLabel.text = coupon.final_price;
    _productPriceLabel.text = coupon.total_price;
}

@end
