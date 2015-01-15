//
//  SCSelectedView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/11.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSelectedView : UIView

@property (nonatomic, assign) BOOL canSelected;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

- (void)selected;

- (void)updateArrowIcon;

@end
