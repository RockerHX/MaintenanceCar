//
//  SCOderAppraisedCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderAppraisalCell.h"

@class SCStarView;

@interface SCOderAppraisedCell : SCOderAppraisalCell

@property (weak, nonatomic) IBOutlet SCStarView *startView;
@property (weak, nonatomic) IBOutlet    UILabel *appraisalLabel;

@end
