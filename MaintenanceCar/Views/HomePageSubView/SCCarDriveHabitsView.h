//
//  SCCarDriveHabitsView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDriveHabitsItem;

@interface SCCarDriveHabitsView : UIView

@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *normalItem;
@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *highItem;
@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *oftenItem;

@end
