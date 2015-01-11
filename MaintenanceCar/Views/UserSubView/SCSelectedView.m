//
//  SCSelectedView.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCSelectedView.h"
#import "MicroCommon.h"

@interface SCSelectedView ()

@end

@implementation SCSelectedView

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleColumnTaped)]];
}

#pragma mark - Private Methods
- (void)titleColumnTaped
{
    if (_canSelected)
    {
        CGFloat minConstant = 40.0f;
        CGFloat maxConstant = SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - minConstant - 4.0f;
        
        _topHeightConstraint.constant = (_topHeightConstraint.constant > minConstant) ? minConstant : maxConstant;
        _bottomHeightConstraint.constant = (_topHeightConstraint.constant > minConstant) ? minConstant : maxConstant;
        
        __weak typeof(self) weakSelf = self;
        [self needsUpdateConstraints];
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [weakSelf layoutIfNeeded];
        } completion:nil];
    }
}

@end
