//
//  SCCouponCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/14.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"
#import "SCCoupon.h"

@interface SCCouponCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UILabel *validDateLabel;

- (CGFloat)displayCellWithCoupon:(SCCoupon *)coupon;

@end
