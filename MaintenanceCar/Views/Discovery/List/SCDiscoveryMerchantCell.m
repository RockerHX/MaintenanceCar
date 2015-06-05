//
//  SCDiscoveryMerchantCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/6/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCDiscoveryMerchantCell.h"

@implementation SCDiscoveryMerchantCell

#pragma mark - Draw Methods
- (void)drawRect:(CGRect)rect
{
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET*3);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 3.0f;
}

@end
