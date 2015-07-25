//
//  SCUserCenterMenuItem.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuItem.h"
#import "SCUserCar.h"

@implementation SCUserCenterMenuItem

#pragma mark - Init Methods
- (instancetype)initWithCar:(SCUserCar *)car {
    NSDictionary *dic = @{@"Icon": @"",
                         @"Title": car.model_name};
    return [self initWithDictionary:dic localData:NO];
}

- (instancetype)initWithDictionary:(NSDictionary *)dic localData:(BOOL)local {
    self = [super init];
    if (self) {
        _localData = local;
        _icon = dic[@"Icon"];
        _title = dic[@"Title"];
    }
    return self;
}

@end
