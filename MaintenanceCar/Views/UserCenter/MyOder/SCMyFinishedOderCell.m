//
//  SCMyFinishedOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyFinishedOderCell.h"
#import "SCStarView.h"

@implementation SCMyFinishedOderCell

#pragma mark - Action Methods
- (IBAction)appraiseButtonPressed:(id)sender
{
    
}

#pragma mark - Private Methods
- (void)showComment
{
    _starPromptLabel.hidden            = YES;
    _starView.hidden                   = YES;
    _appraiseButton.hidden             = NO;
    _starPromptLabelTopHeight.constant = ZERO_POINT;
    _starPromptLabelHeight.constant    = ZERO_POINT;
    _starViewHeight.constant           = ZERO_POINT;
}

- (void)hidComment
{
    [self showComment];
    _appraiseButton.hidden             = YES;
}

- (void)showStar
{
    _starPromptLabel.hidden            = NO;
    _starView.hidden                   = NO;
    _appraiseButton.hidden             = YES;
    _starPromptLabelTopHeight.constant = 20.0f;
    _starPromptLabelHeight.constant    = 21.0f;
    _starViewHeight.constant           = 21.0f;
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithReservation:(SCMyFinishedOder *)oder index:(NSInteger)index
{
    [super displayCellWithReservation:oder index:index];
    
    BOOL canComment = oder.canComment;
    if (!canComment)
    {
        if ([oder.star length])
        {
            [self showStar];
            _starView.value = oder.star;
        }
        else
            [self hidComment];
    }
    else
        [self showComment];
    
    return [self layoutSizeFittingSize];
}

@end
