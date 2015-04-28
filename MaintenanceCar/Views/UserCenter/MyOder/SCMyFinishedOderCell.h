//
//  SCMyFinishedOderCell.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/4/21.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCMyOderCell.h"
#import "SCMyFinishedOder.h"

@class SCStarView;

@interface SCMyFinishedOderCell : SCMyOderCell

@property (weak, nonatomic) IBOutlet            UILabel *starPromptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starPromptLabelTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starPromptLabelHeight;
@property (weak, nonatomic) IBOutlet         SCStarView *starView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starViewHeight;
@property (weak, nonatomic) IBOutlet           UIButton *appraiseButton;

- (IBAction)appraiseButtonPressed:(id)sender;

@end
