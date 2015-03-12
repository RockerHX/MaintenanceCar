//
//  SCOderUnAppraisalCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/3/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCOderCell.h"

@interface SCOderUnAppraisalCell : SCOderCell

@property (weak, nonatomic) IBOutlet UIButton *appraiseButton;

- (IBAction)appraiseButtonPressed:(id)sender;

@end
