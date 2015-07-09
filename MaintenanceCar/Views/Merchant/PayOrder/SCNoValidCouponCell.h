//
//  SCNoValidCouponCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@interface SCNoValidCouponCell : SCTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

-  (void)displayWithPriceConfirm:(BOOL)confirm;

@end
