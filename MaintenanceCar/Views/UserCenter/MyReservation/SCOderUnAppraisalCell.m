//
//  SCOderUnAppraisalCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderUnAppraisalCell.h"

@implementation SCOderUnAppraisalCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _appraiseButton.layer.cornerRadius = 3.0f;
    _appraiseButton.layer.borderColor  = ThemeColor.CGColor;
    _appraiseButton.layer.borderWidth  = 1.0f;
}

#pragma mark - Action Methods
- (IBAction)appraiseButtonPressed:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shouldAppraiseOderWithReservation:)])
        [_delegate shouldAppraiseOderWithReservation:self.reservation];
}

@end
