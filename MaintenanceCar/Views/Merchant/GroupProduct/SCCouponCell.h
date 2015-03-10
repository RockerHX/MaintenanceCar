//
//  SCCouponCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/9.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCouponCodeCell.h"

@interface SCCouponCell : SCCouponCodeCell

@property (weak, nonatomic) IBOutlet  UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet  UILabel *productPriceLabel;

@end
