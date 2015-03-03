//
//  SCGroupProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/2.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCGroupProductCell.h"

@implementation SCGroupProductCell

- (void)awakeFromNib {
    // Initialization code
}

#pragma mark - Action Methods
- (IBAction)bugProductButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldShowBuyProductView)])
        [_delegate shouldShowBuyProductView];
}

@end
