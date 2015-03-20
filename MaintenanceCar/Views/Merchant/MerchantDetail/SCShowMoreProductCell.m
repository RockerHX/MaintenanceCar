//
//  SCShowMoreProductCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShowMoreProductCell.h"

@implementation SCShowMoreProductCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    _state = SCSCShowMoreCellStateDown;
}

#pragma mark - Setter And Getter Methods
- (void)setState:(SCSCShowMoreCellState)state
{
    _state = state;
    
    if (state == SCSCShowMoreCellStateDown)
    {
        self.promptLabel.text = [NSString stringWithFormat:@"全部%@款团购", @(_productCount)];
        _arrowIcon.transform = CGAffineTransformIdentity;
    }
    else
    {
        self.promptLabel.text = @"收起";
        _arrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

#pragma mark - Public Methods
- (void)displayCellWithProductCount:(NSInteger)productCount
{
    _productCount = productCount;
    self.state = _state;
}

@end
