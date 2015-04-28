//
//  SCMyOderDetailProgressCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/27.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderDetailProgressCell.h"
#import "SCMyOderDetail.h"

typedef NS_ENUM(NSUInteger, SCMyOderDetailProgressState) {
    SCMyOderDetailProgressStateUnStart,
    SCMyOderDetailProgressStateDoing,
    SCMyOderDetailProgressStateDone
};

@implementation SCMyOderDetailProgressCell

#pragma mark - Setter And Getter Methods
- (void)setFrame:(CGRect)frame
{
    frame.size.height = frame.size.height + 30.0f;
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
        case SCMyOderDetailProgressStateUnStart:
            break;
        case SCMyOderDetailProgressStateDoing:
        {
            upLineImageName  = @"Line-Solid-V";
            dotIconImageName = @"DotIcon-Big";
            dotIconWidth     = 16.0f;
            
            nameLabelColor    = [UIColor blackColor];
            font = [UIFont boldSystemFontOfSize:18.0f];
        }
            break;
        case SCMyOderDetailProgressStateDone:
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
- (CGFloat)displayCellWithDetail:(SCMyOderDetail *)detail index:(NSInteger)index
{
    SCMyOderDetailProgress *progress = detail.processes[index];
    
    [self restoreProgressState];
    [self displayProgressState:progress.flag];
    if (!index)
        _upLine.hidden = YES;
    else if (index == (detail.processes.count-1))
        _downLine.hidden = YES;
    
    _dateLabel.text = progress.date;
    _nameLabel.text = progress.name;
    
    return [self layoutSizeFittingSize];
}

@end
