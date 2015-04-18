//
//  SCCommentGroup.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/10.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCommentGroup.h"
#import "SCMerchantDetail.h"

@implementation SCCommentMore

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        _commentsCount = detail.comments.count;
    }
    return self;
}

@end


@implementation SCCommentGroup

#pragma mark - Init Methods
- (instancetype)initWithMerchantDetail:(SCMerchantDetail *)detail
{
    self = [super initWithMerchantDetail:detail];
    if (self)
    {
        _comments = detail.comments;
    }
    return self;
}

#pragma mark - Setter And Getter
- (NSInteger)displayRow
{
    return _comments.count;
}

@end
