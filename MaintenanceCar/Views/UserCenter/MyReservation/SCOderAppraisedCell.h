//
//  SCOderAppraisedCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"

@class SCStarView;

@interface SCOderAppraisedCell : SCOderCell

@property (weak, nonatomic) IBOutlet SCStarView *startView;
@property (weak, nonatomic) IBOutlet    UILabel *appraisalLabel;

@end
