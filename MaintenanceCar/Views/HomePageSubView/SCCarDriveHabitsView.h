//
//  SCCarDriveHabitsView.h
//  MaintenanceCar
//
//  Created by ShiCang on 15/1/19.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDriveHabitsItem.h"

@protocol SCCarDriveHabitsViewDelegate <NSObject>

@optional
- (void)didSaveWithHabitsType:(SCHabitsType)type;

@end

@interface SCCarDriveHabitsView : UIView

@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *normalItem;
@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *highItem;
@property (weak, nonatomic) IBOutlet SCDriveHabitsItem *oftenItem;

@property (nonatomic, weak)          id                <SCCarDriveHabitsViewDelegate>delegate;
@property (nonatomic, assign)        SCHabitsType      habitsType;

- (IBAction)saveButtonPressed:(UIButton *)sender;

@end
