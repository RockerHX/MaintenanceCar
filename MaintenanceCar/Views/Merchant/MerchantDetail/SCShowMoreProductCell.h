//
//  SCShowMoreProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShowMoreCell.h"

typedef NS_ENUM(NSInteger, SCSCShowMoreCellState) {
    SCSCShowMoreCellStateDown,
    SCSCShowMoreCellStateUp
};

@interface SCShowMoreProductCell : SCShowMoreCell

@property (weak, nonatomic)    IBOutlet UIImageView *arrowIcon;

@property (nonatomic, assign)             NSInteger productCount;
@property (nonatomic, assign) SCSCShowMoreCellState state;

- (void)displayCellWithProductCount:(NSInteger)productCount;

@end
