//
//  SCGroupProductDetailCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/3.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductDetailCell.h"

@implementation SCGroupProductDetailCell

#pragma mark - Action Methods
- (IBAction)bugProductButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldShowBuyProductView)])
        [_delegate shouldShowBuyProductView];
}

@end
