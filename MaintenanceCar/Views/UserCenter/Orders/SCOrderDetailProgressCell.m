//
//  SCOrderDetailProgressCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOrderDetailProgressCell.h"
#import "SCOrderDetail.h"

typedef NS_ENUM(NSUInteger, SCOrderDetailProgressState) {
    SCOrderDetailProgressStateUnStart,
    SCOrderDetailProgressStateDoing,
    SCOrderDetailProgressStateDone
};

@implementation SCOrderDetailProgressCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.size.height = frame.size.height + 10.0f;
    [super setFrame:frame];
}

#pragma mark - Private Methods
- (void)restoreProgressState
{
    _upLine.hidden   = NO;
    _downLine.hidden = NO;
}

- (void)displayProgressState:(NSInteger)state
{
    NSString *upLineImageName  = @"Line-Dashed-V";
    NSString *dotIconImageName = @"DotIcon-Small";
    NSString *downLinImageName = @"Line-Dashed-V";
    CGFloat dotIconWidth       = 8.0f;

    UIColor *nameLabelColor    = [UIColor grayColor];
    UIFont *font                = [UIFont boldSystemFontOfSize:15.0f];
    switch (state)
    {
        case SCOrderDetailProgressStateUnStart:
            break;
        case SCOrderDetailProgressStateDoing:
        {
            upLineImageName  = @"Line-Solid-V";
            dotIconImageName = @"DotIcon-Big";
            dotIconWidth     = 16.0f;
            
            nameLabelColor    = [UIColor blackColor];
            font = [UIFont boldSystemFontOfSize:18.0f];
        }
            break;
        case SCOrderDetailProgressStateDone:
        {
            upLineImageName  = @"Line-Solid-V";
            downLinImageName = @"Line-Solid-V";
        }
            break;
    }
    _upLine.image          = [UIImage imageNamed:upLineImageName];
    _dotIcon.image         = [UIImage imageNamed:dotIconImageName];
    _downLine.image        = [UIImage imageNamed:downLinImageName];
    _dotIconWidth.constant = dotIconWidth;

    _nameLabel.textColor   = nameLabelColor;
    _nameLabel.font        = font;
}

#pragma mark - Public Methods
- (void)displayCellWithDetail:(SCOrderDetail *)detail index:(NSInteger)index
{
    CGFloat width = SELF_WIDTH;
    CGFloat height = SELF_HEIGHT;
    UIBezierPath *path = [self shadowPathWithPoints:@[@[@(ZERO_POINT), @(-SHADOW_OFFSET*4)],
                                                      @[@(ZERO_POINT), @(height)],
                                                      @[@(SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width - SHADOW_OFFSET*2), @(height - SHADOW_OFFSET*6)],
                                                      @[@(width), @(height + SHADOW_OFFSET*4)],
                                                      @[@(width), @(-SHADOW_OFFSET*4)],
                                                      @[@(width - SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)],
                                                      @[@(SHADOW_OFFSET*2), @(SHADOW_OFFSET*6)]]];
    self.layer.shadowPath = path.CGPath;
    SCOrderDetailProgress *progress = detail.processes[index];
    [self restoreProgressState];
    [self displayProgressState:progress.flag];
    if  (index == (detail.processes.count-1))
    {
        self.layer.shadowPath = nil;
        _downLine.hidden = YES;
    }
    else if (!index)
        _upLine.hidden = YES;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(SHADOW_OFFSET, SHADOW_OFFSET);
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = 1.0f;
    
    _dateLabel.text = progress.date;
    _nameLabel.text = progress.name;
}

@end
