//
//  SCTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@implementation SCTableViewCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + 5.0f;
    frame.size.width = frame.size.width - 20.0f;
    frame.size.height = frame.size.height - 10.0f;
    [super setFrame:frame];
}

#pragma mark - Public Methods
- (CGFloat)layoutSizeFittingSize
{
    CGFloat separatorHeight = 1.0f;
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + separatorHeight + 10.0f;
}

@end
