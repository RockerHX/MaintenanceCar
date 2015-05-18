//
//  SCTableViewCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCTableViewCell.h"

@implementation SCTableViewCell

#pragma mark - Init Methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
}

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    // V2卡片设计
    frame.origin.x = 10.0f;
    frame.origin.y = frame.origin.y + 10.0f;
    frame.size.width = frame.size.width - 20.0f;
    frame.size.height = frame.size.height - 10.0f;
    [super setFrame:frame];
}

#pragma mark - Public Methods
- (CGFloat)layoutSizeFittingSize
{
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 10.0f;
}

@end
