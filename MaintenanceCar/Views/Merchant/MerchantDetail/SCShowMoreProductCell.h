//
//  SCShowMoreProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShowMoreCell.h"

@class SCMerchantGroup;

typedef NS_ENUM(BOOL, SCSCShowMoreCellState) {
    SCSCShowMoreCellStateDown,
    SCSCShowMoreCellStateUp
};

@interface SCShowMoreProductCell : SCShowMoreCell

@property (weak, nonatomic)    IBOutlet UIImageView *arrowIcon;

@property (nonatomic, assign)             NSInteger productCount;
@property (nonatomic, assign) SCSCShowMoreCellState state;

- (void)displayCellWithMerchantGroup:(SCMerchantGroup *)merchantGroup;

@end
