//
//  SCCouponDetailRuleCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/18.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@class SCCoupon;

@interface SCCouponDetailRuleCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

- (CGFloat)displayCellWithCoupon:(SCCoupon *)coupon;

@end
