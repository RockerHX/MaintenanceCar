//
//  SCUserCenterUserCarCell.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterCell.h"

@class SCUserCar;

@protocol SCUserCenterUserCarCellDelegate <NSObject>

@optional
- (void)shouldEditUserCarData:(SCUserCar *)userCar;

@end


@interface SCUserCenterUserCarCell : SCUserCenterCell

@property (weak, nonatomic) IBOutlet id  <SCUserCenterUserCarCellDelegate>delegate;

- (IBAction)editButtonPressed;

- (void)displayCellWithItem:(SCUserCenterMenuItem *)item selected:(BOOL)selected;

@end
