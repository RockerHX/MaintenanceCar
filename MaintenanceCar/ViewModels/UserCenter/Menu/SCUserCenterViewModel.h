//
//  SCUserCenterViewModel.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuItem.h"

@interface SCUserCenterViewModel : NSObject

+ (instancetype)instance;

@property (nonatomic, strong) NSArray *userCars;
@property (nonatomic, strong) NSArray *userCenterItems;

@end
