//
//  SCMyFinishedOderCell.m
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyFinishedOderCell.h"

@implementation SCMyFinishedOderCell

#pragma mark - Action Methods
- (IBAction)appraiseButtonPressed:(id)sender
{
    
}

#pragma mark - Public Methods
- (CGFloat)displayCellWithReservation:(SCMyOder *)oder index:(NSInteger)index
{
    [super displayCellWithReservation:oder index:index];
    
    return [self layoutSizeFittingSize];
}

@end
