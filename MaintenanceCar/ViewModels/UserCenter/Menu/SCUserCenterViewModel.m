//
//  SCUserCenterViewModel.m
//  MaintenanceCar
//
//  Created by Andy on 15/7/23.
//  Copyright (c) 2015年 MaintenanceCar. All rights reserved.
//

#import "SCUserCenterViewModel.h"
#import "SCFileManager.h"

@implementation SCUserCenterViewModel

#pragma mark - Init Methods
+ (instancetype)instance {
    SCUserCenterViewModel *model = [[SCUserCenterViewModel alloc] init];
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig {
    NSMutableArray *items = @[].mutableCopy;
    NSArray *userCenterItems = [self loadUserCenterItems];
    for (NSDictionary *dic in userCenterItems) {
        SCUserCenterMenuItem *item = [[SCUserCenterMenuItem alloc] initWithDictionary:dic localData:YES];
        [items addObject:item];
    }
    _userCenterItems = [NSArray arrayWithArray:items];
}

#pragma mark - Private Methods
- (NSArray *)loadUserCenterItems {
    return [NSArray arrayWithContentsOfFile:[NSFileManager pathForResource:@"UserCenterData" ofType:@"plist"]];
}

@end
