//
//  SCMerchantDetailFlagCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/2/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMerchantDetailFlagCell.h"

@implementation SCMerchantDetailFlagCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth  = 0.5f;
}

#pragma mark - Setter And Getter Methods
- (void)setColor:(UIColor *)color
{
    _color = color;
    
    _flagLabel.backgroundColor = color;
    self.layer.borderColor     = color.CGColor;
}

@end
