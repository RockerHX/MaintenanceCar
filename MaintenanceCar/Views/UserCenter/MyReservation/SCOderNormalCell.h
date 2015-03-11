//
//  SCOderNormalCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"

@class SCGetCarDaysView;

@interface SCOderNormalCell : SCOderCell

@property (weak, nonatomic) IBOutlet          UILabel *getCarDateLabel;
@property (weak, nonatomic) IBOutlet SCGetCarDaysView *getCarDaysView;

@end
