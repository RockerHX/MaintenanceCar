//
//  SCUserCenterMenuItem.h
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCar.h"

@interface SCUserCenterMenuItem : NSObject

@property (nonatomic, assign)             BOOL  last;
@property (nonatomic, assign)             BOOL  selected;
@property (nonatomic, assign, readonly)   BOOL  localData;
@property (nonatomic, copy, readonly) NSString *icon;
@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, copy, readonly) SCUserCar *userCar;

- (instancetype)initWithCar:(SCUserCar *)car;
- (instancetype)initWithDictionary:(NSDictionary *)dic localData:(BOOL)local;

@end
