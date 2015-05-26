//
//  SCNoValidCouponCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/5/26.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCNoValidCouponCell.h"

@implementation SCNoValidCouponCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.y = frame.origin.y - 10.0f;
    frame.size.height = frame.size.height + 10.0f;
    [super setFrame:frame];
}

@end
