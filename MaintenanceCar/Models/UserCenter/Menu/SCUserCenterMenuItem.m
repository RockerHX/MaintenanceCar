//
//  SCUserCenterMenuItem.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterMenuItem.h"

@implementation SCUserCenterMenuItem

#pragma mark - Init Methods
- (instancetype)initWithDictionary:(NSDictionary *)dic localData:(BOOL)local {
    self = [super init];
    if (self) {
        _localData = local;
        _viewController = NSClassFromString(dic[@"ViewController"]);
        _icon = dic[@"Icon"];
        _title = dic[@"Title"];
    }
    return self;
}

@end
