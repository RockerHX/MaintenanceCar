//
//  SCCollectionItem.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/5.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCCollectionItem.h"

@implementation SCCollectionItem

#pragma mark - Public Methods
- (void)setFavorited:(BOOL)favorited
{
    _favorited = favorited;
    [self setImage:[UIImage imageNamed:favorited ? @"FavoriteIcon" : @"UnFavoriteIcon"] forState:UIControlStateNormal];
}

@end
