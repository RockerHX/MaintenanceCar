//
//  SCShowMoreProductCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/16.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCShowMoreCell.h"

@class SCGroupBase;

typedef NS_ENUM(BOOL, SCSCShowMoreCellState) {
    SCSCShowMoreCellStateDown,
    SCSCShowMoreCellStateUp
};

typedef NS_ENUM(BOOL, SCGroupCellType) {
    SCGroupCellTypeGroupProduct,
    SCGroupCellTypeQuotedPrice
};

@interface SCShowMoreProductCell : SCShowMoreCell

@property (weak, nonatomic)    IBOutlet UIImageView *arrowIcon;

@property (nonatomic, assign)             NSInteger productCount;
@property (nonatomic, assign) SCSCShowMoreCellState state;
@property (nonatomic, assign)       SCGroupCellType cellType;

- (void)displayCellWithMerchantGroup:(SCGroupBase *)group;

@end
